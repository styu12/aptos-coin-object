module coin_objects::coin {
    use std::string::{Self, String};
    use std::vector;
    use std::signer;
    use std::bcs;

    use aptos_framework::object::{Self, CreatorRef, ObjectId};
    // no coin resource exists
    const ENO_COINS:u64 = 1;

    /// coins object : represents balances of coin object of buyer, seller, market
    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct Coins<phantom T> has key, store {
        name: String,
        symbol: String,
        balance: u64
    }
    
     /// coin object : when execute withdraw or deposit, it reprensent amount of coin object to withdraw of deposit
    /// when withdraw, deposit is done, the coin object will be deleted
    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct Coin<phantom T> has key, store, drop, copy {
        name: String,
        symbol: String,
        value: u64
    }

    /// mint function for default address
    public fun mint<T>(
        creator: &signer,
        name: String,
        symbol: String,
        amount: u64
    ): ObjectId {
           // make Coins<T> Object
            let my_coins_seed = create_coins_id_seed(&signer::address_of(creator), &name, &symbol);
            let my_coins_creator_ref = object::create_named_object(creator, my_coins_seed);
            let my_coins_object_signer = object::generate_signer(&my_coins_creator_ref);
            let my_coins_object_id = object::address_to_object_id(signer::address_of(&my_coins_object_signer));

            let my_coins = Coins<T> {
                name,
                symbol,
                balance: amount 
            };
            move_to(&my_coins_object_signer, my_coins);
            my_coins_object_id
            // object::address_to_object_id(signer::address_of(&my_coins_object_signer))
    }

     /// mint function for addresses which is not default address
    public fun mint_to<T>(
        creator: &signer,
        to: address,
        name: String,
        symbol: String,
        amount: u64
    ): ObjectId {
           // make Coins<T> Object
            let coins_seed = create_coins_id_seed(&to, &name, &symbol);
            let coins_creator_ref = object::create_named_object(creator, coins_seed);
            let coins_object_signer = object::generate_signer(&coins_creator_ref);
            let coins_object_id = object::address_to_object_id(signer::address_of(&coins_object_signer));

            let coins = Coins<T> {
                name,
                symbol,
                balance: amount
            };

            // create coins object and transfer to creator
            move_to(&coins_object_signer, coins);
            object::transfer(
                creator,
                coins_object_id,
                to
            );
            // coins_creator_ref
            coins_object_id
    }

     /// transfer coin object
    public entry fun transfer(account: &signer, from: address, to: address, amount: u64) {
        // event -> objectId
        let coin_object = coin::withdraw<MirnyCoin>(account, amount, from);
        coin::deposit<MirnyCoin>(to, coin_object);
    } 

    /// withdraw from coins object
    public fun withdraw<T>(
        account: &signer, 
        amount: u64,
        coins: address
    ): Coin<T> acquires Coins, Coin {
        assert!(exists<Coins<T>>(coins), ENO_COINS);
        let coins_obj = borrow_global_mut<Coins<T>>(coins);
        coins_obj.balance = coins_obj.balance - amount;

        let coin_creator_ref = initialize_coin<T>(
            account,
            coins_obj.name,
            coins_obj.symbol,
            amount,
        );

        let coin_object_signer = object::generate_signer(&coin_creator_ref);
        let coin_object_id = object::address_to_object_id(signer::address_of(&coin_object_signer));
        let coin_obj = move_from<Coin<T>>(object::object_id_address(&coin_object_id));
        std::debug::print(&string::utf8(b"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"));
        std::debug::print(&string::utf8(b"Coin Object Created!!! The value amount is "));
        std::debug::print(&coin_obj.value);
        std::debug::print(&string::utf8(b"[Coin Object Address]"));
        std::debug::print(&object::object_id_address(&coin_object_id));
        std::debug::print(&string::utf8(b" "));
        coin_obj
    }
    

    /// add coin object balance
    public fun deposit<T>(
        to: address, 
        coin_to_deposit: Coin<T>
    )  acquires Coins {
        assert!(exists<Coins<T>>(to), ENO_COINS);
        let dst_coins_object = borrow_global_mut<Coins<T>>(to);
        dst_coins_object.balance = dst_coins_object.balance + coin_to_deposit.value;
    }

    /// define coin object's property and set seller, buyer, market's balance
    fun initialize_coin<T>(
        creator: &signer,
        name: String,
        symbol: String,
        amount: u64
    ): CreatorRef {
        // make coin object
        let coin_seed = create_coin_id_seed(&name, &symbol);
        let coin_creator_ref = object::create_object_from_account(creator);
        // let coin_creator_ref = object::create_named_object(creator, coin_seed);
        let coin_object_signer = object::generate_signer(&coin_creator_ref);

        let coin = Coin<T> {
            name,
            symbol,
            value: amount
        };

        move_to(&coin_object_signer, coin);
        coin_creator_ref
    }

    /// create seed for coin object
    fun create_coin_id_seed(name: &String, symbol: &String): vector<u8> {
        let seed = *string::bytes(name);
        vector::append(&mut seed, b"::");
        vector::append(&mut seed, *string::bytes(symbol));
        seed
    }

     /// create seed for coins object
    public fun create_coins_id_seed(creator_address: &address, name: &String, symbol: &String): vector<u8> {
        let seed = bcs::to_bytes(creator_address);
        vector::append(&mut seed, b"::");
        vector::append(&mut seed, *string::bytes(name));
        vector::append(&mut seed, b"::");
        vector::append(&mut seed, *string::bytes(symbol));
        seed
    }
}

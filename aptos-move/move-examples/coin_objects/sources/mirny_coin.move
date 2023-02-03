module coin_objects::mirny_coin {
    use std::string::{Self, String};
    use std::signer;
    use coin_objects::coin;
    use coin_objects::mirny_token;

    use aptos_framework::object::{Self, CreatorRef, ObjectId};

    const SELLER:address = @0x225751338aaf9466d5571683c8a6fe311223aae83a06c2e302368b2ba997dfcb;
    const BUYER:address = @0x6177a48e9afacee44f652ccf5bb3a8b41799ed359782f591480e53737e6e8eb5;

    const SELLER_INITIAL_BALANCE: u64 = 400;
    const BUYER_INITIAL_BALANCE: u64 = 3200;

    struct MirnyCoin {} 

    public entry fun mint(account: &signer) {
        // create seller coin object (balance : 0)
        let seller_coins_object_id = coin::mint_to<MirnyCoin>(
            account,
            SELLER,
            string::utf8(b"Mirny Coin"),
            string::utf8(b"MIR"),
            SELLER_INITIAL_BALANCE
        ); 
        mirny_token::mint_to(account, SELLER);

        let buyer_coins_object_id = coin::mint_to<MirnyCoin>(
            account,
            BUYER,
            string::utf8(b"Mirny Coin"),
            string::utf8(b"MIR"),
            BUYER_INITIAL_BALANCE
        );
        // let mirny_coins_object_id = coin::mint<MirnyCoin>(
        //     account,
        //     string::utf8(b"Mirny Coin"),
        //     string::utf8(b"MIR"),
        //     0
        // );
    }
    
    //  public entry fun swap_middle(account: &signer) {
    //     transfer(account, BUYER_OBJ, MIRNY_OBJ, SWAP_AMOUNT);
    //     seller -> mirny token
    // }
    // public entry fun swap_final (account: &signer) {
    //     transfer(account, MIRNY_OBJ, SELLER_OBJ, SWAP_AMOUNT);
    //     mirny -> buyer -> token
    // }

    // public fun transfer(account: &signer, from: address, to: address, amount: u64) {
    //     // event -> objectId
    //     let coin_object = coin::withdraw<MirnyCoin>(account, amount, from);
    //     coin::deposit<MirnyCoin>(to, coin_object);
    // } 

}
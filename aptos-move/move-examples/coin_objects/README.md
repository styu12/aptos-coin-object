# Coin Objects
## 🔥Shout out to David Wolinsky🔥 
based on `0x1::aptos_framework::object module` made by David Wolinsky
[his TokenObjects Module](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/move-examples/token_objects)

## Abstract
The current Aptos explorer and the fullnode REST API fall short to provide an interface for querying object-based tokens and coins. Thus, to complete our project, we plan to develop and operate an indexer API for querying object-based coins and tokens. We plan to provide the APIs to the broader Aptos community so that developers can easily work with objects in Aptos.

## Timeline
It will take us around 4 months to provide APIs for querying object-based coins and tokens. After 4 months, we will continue to improve the APIs in terms of latency, scalability, and reliability. We will also develop “stream APIs” for notifying users of changes in object-based coins and tokens in the Aptos blockchain. We will work closely with the Aptos community including Metapixel, which heavily uses objects.

## What we are planning to create
- `ObjectProcessor.rs` for indexing Object data at indexer full node
- REST API Service for querying our indexer DB, such as `/api/v1/objects`, `/api/v1/coinObjects`, `/api/v1/tokenObjects`

## Our Design - Module Coin
### Coins 
```
Object {
    Coins<T> {
        Balance
    }
}
```
### Coin
```
Object {
    Coin<T> {
        Value
    }
}
```

### Transfer 
```
 public entry fun transfer(account: &signer, from: address, to: address, amount: u64) {
        // event -> objectId
        let coin_object = coin::withdraw<MirnyCoin>(account, amount, from);
        coin::deposit<MirnyCoin>(to, coin_object);
    } 
```
- withdraw()
1. Decrease the balance of Coins_Object of from account
2. Create a new Coin_Object containing that amount of value
- deposit()
 1. get Coin_Object which withdraw() returns
 2. Increase the balance of Coins_Object of to account
  Finally, delete the Coin_Object of global storage. 

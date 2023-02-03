# Coin Objects
## 🔥Shout out to David Wolinsky🔥 
based on `0x1::aptos_framework::object module` made by David Wolinsky
[his TokenObjects Module](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/move-examples/token_objects)

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

## What we are planning to create
- `Swap` between `CoinObjects` and `TokenObjects`
- `Bidding` system, which are available in dApps, especially NFT marketplaces
- `Approve & Allowance` system of ERC20 in Aptos 
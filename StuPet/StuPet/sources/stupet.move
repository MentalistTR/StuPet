module stupet::stupet {
    use std::string::String;
    use sui::tx_context::TxContext;
    use sui::random::{Random, new_generator,generate_u8_in_range};
    use sui::object::delete;
    use sui::transfer::{share_object, transfer, public_transfer};
    use sui::tx_context::sender;
    use sui::table::{Table, Self};
    use std::vector;
    use sui::object::UID;
    use sui::dynamic_object_field as dof;

//===========ERROR========

    const ETypeAlreadyExist:u64 = 0;
    const ETypeNotExist:u64 = 1;
//===========Struct========
    public struct Item has key,store{
        id:UID,
        name:String,
        type:String,
        description:String,
    }
    
    struct Table_pool has key,store{
        id:UID,
        table_values: Table<Item, u64>,
    }

    public struct Pet has key,store{
        id:UID,
        name:String,
        grade:String,
        birthdate:u64,
        attributes:vector<String>,
        owner:address
    }

    public struct AdminCap has key,store{
        id:UID
    }

    //===========init==========
    fun init(ctx:&mut TxContext){
        let admin_cap = AdminCap{id:object::new(ctx)};
        transfer::transfer(admin_cap,sender(ctx));
    }

      //===========functions==========
    
    public fun uid_mut<T>(pet: &mut Pet): &mut UID { &mut pet.id }
    
    public fun create_table<Item,String>(ctx: &mut TxContext): Table<Item, String> {
        Table<Item, String> {
            table_values: table::new<Item, String>(ctx)
        }
    }
    
    public fun mint_pet_nft (
        ctx:&mut TxContext,
        pet_name:String,
        grade:String,
        birthdate:u64,
        ){
            let pet = Pet{
            id:object::new(ctx);
            name:pet_name,
            grade:grade,
            birthdate:birthdate,
            attributes:vector<String>,
            owner:sender(ctx);
        }
        transfer::transfer(pet,sender(ctx));
        }

    
    public fun mint_Item_to_table(_:AdminCap,name:String,type:String,description:String,n:u64,ctx:&mut TxContext,table:&mut Table<Item, u64>){
        let mut i = 0;
        while (i < n){
        let items = Item{
            id:object::new(ctx),
            name:name,
            type:type,
            description:description
        }
        table::add(&mut table.table_valuesitem,item,i);
        i = i + 1;
        };
    }
    
    public fun remove_item_tabel(_:AdminCap,table:&mut Table<Item, u64>,k:u64):Item{
        table::remove(&mut table.table_values,item);
    }

    public fun random_item(nft:&mut Table<Item, u64>,ran:&Random,ctx:&mut TxContext,k:u64):Item{
        let gen = new_generator(ran,ctx);
        let v = random::generate_u8_in_range(&mut gen,1,10);
        if(v == k){
            let item = remove_item_tabel(nft,k);
            transfer::transfer(item,sender(ctx));
        item
        }
    }
    
    public fun add_item_to_pet(pet:&mut Pet,item:Item){
        let uid_mut = uid_mut(pet);
        assert!(!dof::exists_(uid_mut, Item{ type: item.type }), ETypeAlreadyExist);
        dof::add(uid_mut, Item{ type: item.type }, accessory)
    }

    

    public fun remove_item_from_pet(pet:&mut Pet,item:Item){
        let uid_mut = uid_mut(pet);
        assert!(!dof::exists_(uid_mut, Item {type: item.type }), ETypeNotExist);
        dof::remove(uid_mut,Item { type:item.type })
    }

public fun updatepet_grade(pet:&mut Pet,new_grade:String){
        pet.grade = new_grade
    }
    public fun burn(_:AdminCap,item:Item){
        let Item{id,name:_, type:_, description:_} = item;
        object::delete(id);
    }

    
    



    
//===========read==========
    public fun name(pet:Pet):String{
        pet.name
    }

    public fun grade(pet:Pet):String{
        pet.grade
    }

    public fun birthdate(pet:Pet):u64{    
        pet.birthdate
    }

    public fun attributes(pet:Pet):vector<String>{
        pet.attributes
    }
}
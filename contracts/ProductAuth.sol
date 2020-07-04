pragma solidity >=0.4.21 <0.7.0;
/// @title ProductAuthentication
/// @author sahisnu
contract ProductAuth{
    uint product_id;
    enum prod_stage{
        MANUFACTURED,
        ASSEMBLED,
        DISTRIBUTED
    }
    struct product_info{
        prod_stage step;
        uint stage;
    //manufacurer specific
        string name;
        string description;
        address owner;
        string manufacturer_name;
        string manufacturer_location;
        uint manufactured_time;
    //assembler specific
        string assembler_name;
        string assembler_location;
        uint assembled_time;
    //distributor specific
        string distributor_name;
        string distributor_location;
        uint distributed_time;

    }
    mapping(uint => product_info) product_map;
    address owner_id;

    modifier afterManufacture(uint _productId){
        require(product_map[_productId].step==prod_stage.MANUFACTURED, "Manufacture record not found for the product");
        _;
    }
    modifier afterAssembly(uint _productId){
        require(product_map[_productId].step==prod_stage.ASSEMBLED, "Assembly record not found for the product");
        _;
    }
    modifier afterDistribute(uint _productId){
        require(product_map[_productId].step==prod_stage.DISTRIBUTED, "Distribution record not found for the product");
        _;
    }
    modifier checkId(uint _productId){
        require(_productId<product_id && _productId>0, "Invalid product_id");
        _;
    }

    constructor() public{
        owner_id = msg.sender;
    }
    function manufactureBlock(string memory name,
        string memory description,
        string memory manufacturer_name,
        string memory manufacturer_location
        ) public returns (uint _productId) {
            product_map[product_id] = product_info(
                prod_stage.MANUFACTURED,
                1,
                name,
                description,
                msg.sender,
                manufacturer_name,
                manufacturer_location,
                block.timestamp,
                "",
                "",
                0,
                "",
                "",
                0

            );
            product_id = product_id+1;
            return (product_id-1);
    }

    function assemblyBlock(uint _productId,
        string memory assembler_name,
        string memory assembler_location)
        public
        afterManufacture(_productId)
        checkId(_productId)  {
            product_info storage pdt = product_map[_productId];
            pdt.step = prod_stage.ASSEMBLED;
            pdt.stage = 2;
            pdt.assembler_name = assembler_name;
            pdt.assembler_location = assembler_location;
            pdt.assembled_time = block.timestamp;
    }

    function distributeBlock(uint _productId,
        string memory distributor_name,
        string memory distributor_location)
        public
        afterAssembly(_productId)
        checkId(_productId)  {
            product_info storage pdt = product_map[_productId];
            pdt.step = prod_stage.DISTRIBUTED;
            pdt.stage = 3;
            pdt.distributor_name = distributor_name;
            pdt.distributor_location = distributor_location;
            pdt.distributed_time = block.timestamp;
    }

    // function getProductDetails(uint _productId) public view
    // afterDistribute(_productId)
    // checkId(_productId)returns(
    //     string  memory name,
    //     string memory description,
    //     address owner,
    //     string memory manufacturer_name,
    //     string memory manufacturer_location,
    //     uint manufactured_time,
    //     string memory assembler_name,
    //     string memory assembler_location,
    //     uint assembled_time,
    //     string memory distributor_name,
    //     string memory distributor_location,
    //     uint distributed_time)
    // {
    //     product_info storage pdt = product_map[_productId];
    //     return(pdt.name,pdt.description,pdt.owner,pdt.manufacturer_name,pdt.manufacturer_location,pdt.manufactured_time,
    //     pdt.assembler_name,pdt.assembler_location,pdt.assembled_time,pdt.distributor_name,pdt.distributor_location,distributed_time);
    // }

    function getManufactureDetails(uint _productId) public view
    checkId(_productId) returns (string memory name,
        string memory description,
        address  owner,
        string memory manufacturer_name,
        string memory manufacturer_location,
        uint manufactured_time){
            product_info storage pdt = product_map[_productId];
            require(pdt.stage>=1,"Data Not Found");
            return (pdt.name, pdt.description, pdt.owner, pdt.manufacturer_name, pdt.manufacturer_location, pdt.manufactured_time);
    }

    function getAssemblyDetails(uint _productId) public view
    checkId(_productId) returns (
        string memory assembler_name,
        string memory assembler_location,
        uint assembled_time){
            product_info storage pdt = product_map[_productId];
            require(pdt.stage>=2,"Data Not Found");
            return(pdt.assembler_name,pdt.assembler_location,pdt.assembled_time);
    }

    function getDistributionDetails(uint _productId) public view
    checkId(_productId) returns (
        string memory distributor_name,
        string memory distributor_location,
        uint distributed_time){
            product_info storage pdt = product_map[_productId];
            require(pdt.stage==3,"Data Not Found");
            return(pdt.distributor_name,pdt.distributor_location,pdt.distributed_time);
    }

}
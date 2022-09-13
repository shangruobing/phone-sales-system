-- ----------------------------
-- Table structure for tb_employee
-- ----------------------------
DROP TABLE IF EXISTS `tb_employee`;
CREATE TABLE `tb_employee`  (
  `id` varchar(20) CHARACTER NOT NULL COMMENT '工号',
  `name` varchar(20) CHARACTER NULL DEFAULT NULL COMMENT '姓名',
  `role` varchar(20) CHARACTER NULL DEFAULT NULL COMMENT '工种',
  PRIMARY KEY (`id`) USING BTREE
) 

-- ----------------------------
-- Records of tb_employee
-- ----------------------------
INSERT INTO `tb_employee` VALUES ('1', '倪尔', '库管');
INSERT INTO `tb_employee` VALUES ('2', '尚若冰', '出纳');
INSERT INTO `tb_employee` VALUES ('3', '岳姗', '销售');

-- ----------------------------
-- Table structure for tb_money_account
-- ----------------------------
DROP TABLE IF EXISTS `tb_money_account`;
CREATE TABLE `tb_money_account`  (
  `id` varchar(20) CHARACTER NOT NULL COMMENT '账目号',
  `receipt_id` varchar(20) CHARACTER NOT NULL COMMENT '小票号',
  `employee_id` varchar(20) CHARACTER NOT NULL COMMENT '雇员号',
  `date` datetime NULL DEFAULT NULL COMMENT '账目变动时间',
  `total` decimal(10, 0) NULL DEFAULT NULL COMMENT '变化的金额数目',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK_receipt`(`receipt_id` ASC) USING BTREE,
  INDEX `FK_employee`(`employee_id` ASC) USING BTREE,
  CONSTRAINT `FK_employee` FOREIGN KEY (`employee_id`) REFERENCES `tb_employee` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_receipt` FOREIGN KEY (`receipt_id`) REFERENCES `tb_receipt` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) 

-- ----------------------------
-- Records of tb_money_account
-- ----------------------------
INSERT INTO `tb_money_account` VALUES ('1569184520940867585', '83740811482170739463', '2', '2022-08-02 09:35:00', 6099);
INSERT INTO `tb_money_account` VALUES ('1569189490159308802', '04042828855812258864', '2', '2022-08-04 13:00:00', 8500);

-- ----------------------------
-- Table structure for tb_money_taking
-- ----------------------------
DROP TABLE IF EXISTS `tb_money_taking`;
CREATE TABLE `tb_money_taking`  (
  `id` varchar(20) CHARACTER NOT NULL COMMENT '账目号',
  `beginning_balance` decimal(10, 0) NOT NULL COMMENT '月初金额',
  `ending_balance` decimal(10, 0) NOT NULL COMMENT '月末金额',
  `employee_id` varchar(20) CHARACTER NULL DEFAULT NULL COMMENT '雇员号',
  `date` datetime NULL DEFAULT NULL COMMENT '账目变动时间',
  `total_price` decimal(10, 0) NOT NULL COMMENT '盘点金额',
  `balance` decimal(10, 0) NULL DEFAULT NULL COMMENT '差额',
  `note` varchar(255) CHARACTER NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK_money_taking_employee`(`employee_id` ASC) USING BTREE,
  CONSTRAINT `FK_money_taking_employee` FOREIGN KEY (`employee_id`) REFERENCES `tb_employee` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) 

-- ----------------------------
-- Records of tb_money_taking
-- ----------------------------
INSERT INTO `tb_money_taking` VALUES ('1', 30000, 30000, '2', '2022-08-01 08:00:00', 30000, 0, '启动资金');

-- ----------------------------
-- Table structure for tb_product
-- ----------------------------
DROP TABLE IF EXISTS `tb_product`;
CREATE TABLE `tb_product`  (
  `id` varchar(20) CHARACTER NOT NULL COMMENT '商品号',
  `brand` varchar(20) CHARACTER NULL DEFAULT NULL COMMENT '商品名称',
  `type` varchar(20) CHARACTER NULL DEFAULT NULL COMMENT '商品类型',
  `model` varchar(20) CHARACTER NULL DEFAULT NULL COMMENT '商品规格',
  `price` decimal(10, 0) NULL DEFAULT NULL COMMENT '价格',
  PRIMARY KEY (`id`) USING BTREE
) 

-- ----------------------------
-- Records of tb_product
-- ----------------------------
INSERT INTO `tb_product` VALUES ('25518aa5', 'Redmi', '8G/128G', 'Redmi  K30', 2499);
INSERT INTO `tb_product` VALUES ('2FD0221303041019', 'HUAWEI', ' ', 'Mate40 Pro', 6099);
INSERT INTO `tb_product` VALUES ('3JU5T18411005978', 'HUAWEI', ' ', 'Nova 2s', 2500);
INSERT INTO `tb_product` VALUES ('41845ab5', 'Redmi', ' ', 'Red MI K40', 2199);
INSERT INTO `tb_product` VALUES ('46HDU19801003573', 'HONOR', ' ', 'HONOR V20', 1899);
INSERT INTO `tb_product` VALUES ('4lda7lkj9hba7d7l', 'Mi', '8G/256G', 'Redmi Note 10 Pro', 2099);
INSERT INTO `tb_product` VALUES ('73322793', 'RedMi', '12G/256G', 'K40', 2699);
INSERT INTO `tb_product` VALUES ('85PVTWU8KVI7INUW', 'OPPO', '4G/128G', 'A3', 1499);
INSERT INTO `tb_product` VALUES ('95803209150068I', 'vivo', '12G/256G', 'iQOO Neo5', 2999);
INSERT INTO `tb_product` VALUES ('9b53ef80b20', '小米', '8G/256G', 'Redmi Note 9 4G', 3000);
INSERT INTO `tb_product` VALUES ('9b53ef80b21', '小米', '6G/256G', 'Redmi Note 9 4G', 2000);
INSERT INTO `tb_product` VALUES ('9b53ef80b22', '小米', '6G/128G', 'Redmi Note 9 4G', 1500);
INSERT INTO `tb_product` VALUES ('9b53ef80c21', '小米', '6G/256G', 'Redmi Note 9 4G', 2000);
INSERT INTO `tb_product` VALUES ('9b53ef80d21', '小米', '6G/256G', 'Redmi Note 9 4G', 2000);
INSERT INTO `tb_product` VALUES ('9YE0218524003777', 'HONOR', '6G/128G', 'HONOR 10', 1999);
INSERT INTO `tb_product` VALUES ('A000008515C37D', 'vivo', ' ', 'X21iA', 2000);
INSERT INTO `tb_product` VALUES ('A000008E605bd0', 'HONOR', ' ', 'HONOR 10', 3000);
INSERT INTO `tb_product` VALUES ('A00000D0C7BF37', 'HONOR', '8G/256G', 'HONOR 50Pro', 3699);
INSERT INTO `tb_product` VALUES ('A00000E51DAB2F', 'OPPO', ' ', 'RMX', 3100);
INSERT INTO `tb_product` VALUES ('a08cad5', 'OPPO', ' ', 'R15 梦境版', 3500);
INSERT INTO `tb_product` VALUES ('cdfe6c62', 'Mi', '8G/128G', 'Redmi K30S Ultra', 2500);
INSERT INTO `tb_product` VALUES ('cebe7bc3', 'OPPO', '8G 256G', 'Reno 5', 2988);
INSERT INTO `tb_product` VALUES ('CLB0218502000656', 'HUAWEI', ' ', 'P20', 3800);
INSERT INTO `tb_product` VALUES ('d247c830', 'Mi', '8G/256G', 'Mi 10 Ultra', 3500);
INSERT INTO `tb_product` VALUES ('E6E0220723001011', 'HUAWEI', ' ', 'Nova7', 3000);
INSERT INTO `tb_product` VALUES ('F4GFGS79N742', 'Apple', '4G/128G', 'iPhone 11', 5000);
INSERT INTO `tb_product` VALUES ('F4GWPCBRJC6C', 'iPhone', '4G/128G', 'iPhone8', 2499);
INSERT INTO `tb_product` VALUES ('FD2Y11SGJCLY', 'Apple', ' ', 'iPhone 8 Plus', 2999);
INSERT INTO `tb_product` VALUES ('FFMX8PHEJC6', 'Apple', ' ', 'iPhone8', 2499);
INSERT INTO `tb_product` VALUES ('FJH5T18805009816', 'HUAWEI', ' ', 'Nova 3', 3000);
INSERT INTO `tb_product` VALUES ('FMLDU19B23033370', 'HUAWEI', '4G/128G', 'Nova6', 3500);
INSERT INTO `tb_product` VALUES ('IVZTDUEUS4BQJJHQ', 'OPPO', '8G/128G', 'Reno 6 Pro', 4299);
INSERT INTO `tb_product` VALUES ('KZYDZ9EYINKRGUS8', 'OPPO', ' ', 'A3', 2000);
INSERT INTO `tb_product` VALUES ('NAB0220811028120', 'HUAWEI ', ' ', 'P40', 4500);
INSERT INTO `tb_product` VALUES ('STSDU19703011512', 'HONOR', '8G/256G', 'HONOR 20', 2999);
INSERT INTO `tb_product` VALUES ('U8ENW18479', 'HONOR', ' ', 'HONOR 9', 1599);
INSERT INTO `tb_product` VALUES ('WP0NZG1BCN73Tlm', 'Nokia', ' ', 'C3', 1000);
INSERT INTO `tb_product` VALUES ('WQCDU19815000556', 'HONOR', '6G/128G', 'HONOR 20S', 1999);

-- ----------------------------
-- Table structure for tb_receipt
-- ----------------------------
DROP TABLE IF EXISTS `tb_receipt`;
CREATE TABLE `tb_receipt`  (
  `id` varchar(20) CHARACTER NOT NULL COMMENT '订单号',
  `date` datetime NULL DEFAULT NULL COMMENT '交易日期',
  `total_price` decimal(10, 0) NULL DEFAULT NULL COMMENT '总订单金额',
  `seller` varchar(20) CHARACTER NULL DEFAULT NULL COMMENT '销售工号',
  `cashier` varchar(20) CHARACTER NULL DEFAULT NULL COMMENT '出纳工号',
  `status` int NULL DEFAULT NULL COMMENT '小票状态',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK_seller`(`seller` ASC) USING BTREE,
  INDEX `FK_cashier`(`cashier` ASC) USING BTREE,
  CONSTRAINT `FK_cashier` FOREIGN KEY (`cashier`) REFERENCES `tb_employee` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_seller` FOREIGN KEY (`seller`) REFERENCES `tb_employee` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) 

-- ----------------------------
-- Records of tb_receipt
-- ----------------------------
INSERT INTO `tb_receipt` VALUES ('04042828855812258864', '2022-08-04 12:00:00', 8500, '3', '2', 3);
INSERT INTO `tb_receipt` VALUES ('83740811482170739463', '2022-08-02 09:30:00', 6099, '3', '2', 3);

-- ----------------------------
-- Table structure for tb_receipt_detail
-- ----------------------------
DROP TABLE IF EXISTS `tb_receipt_detail`;
CREATE TABLE `tb_receipt_detail`  (
  `id` varchar(20) CHARACTER NOT NULL COMMENT '小票明细号',
  `product_id` varchar(20) CHARACTER NULL DEFAULT NULL COMMENT '商品号',
  `receipt_id` varchar(20) CHARACTER NULL DEFAULT NULL COMMENT '小票号',
  `quantity` int NULL DEFAULT NULL COMMENT '商品的数量',
  `amount` decimal(10, 0) NULL DEFAULT NULL COMMENT '项目价格总和',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `PK_prodcut`(`product_id` ASC) USING BTREE,
  INDEX `PK_receipt`(`receipt_id` ASC) USING BTREE,
  CONSTRAINT `PK_prodcut` FOREIGN KEY (`product_id`) REFERENCES `tb_product` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `PK_receipt` FOREIGN KEY (`receipt_id`) REFERENCES `tb_receipt` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) 

-- ----------------------------
-- Records of tb_receipt_detail
-- ----------------------------
INSERT INTO `tb_receipt_detail` VALUES ('1569183569190375426', '2FD0221303041019', '83740811482170739463', 1, 6099);
INSERT INTO `tb_receipt_detail` VALUES ('1569188701135228929', 'a08cad5', '04042828855812258864', 1, 3500);
INSERT INTO `tb_receipt_detail` VALUES ('1569188701135228930', '9b53ef80b20', '04042828855812258864', 1, 3000);
INSERT INTO `tb_receipt_detail` VALUES ('1569188701135228931', '9b53ef80d21', '04042828855812258864', 1, 2000);

-- ----------------------------
-- Table structure for tb_stock_account
-- ----------------------------
DROP TABLE IF EXISTS `tb_stock_account`;
CREATE TABLE `tb_stock_account`  (
  `id` varchar(20) CHARACTER NOT NULL COMMENT '账目号',
  `product_id` varchar(20) CHARACTER NOT NULL COMMENT '商品号',
  `employee_id` varchar(20) CHARACTER NOT NULL COMMENT '雇员号',
  `date` datetime NULL DEFAULT NULL COMMENT '账目变动时间',
  `quantity` int NULL DEFAULT NULL COMMENT '商品数量',
  `kept` int NULL DEFAULT NULL COMMENT '实际数量',
  `balance` int NULL DEFAULT NULL COMMENT '差额',
  `note` varchar(255) CHARACTER NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK_stock_product`(`product_id` ASC) USING BTREE,
  INDEX `FK_stock_employee`(`employee_id` ASC) USING BTREE,
  CONSTRAINT `FK_stock_employee` FOREIGN KEY (`employee_id`) REFERENCES `tb_employee` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_stock_product` FOREIGN KEY (`product_id`) REFERENCES `tb_product` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) 

-- ----------------------------
-- Records of tb_stock_account
-- ----------------------------
INSERT INTO `tb_stock_account` VALUES ('1', 'IVZTDUEUS4BQJJHQ', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('10', 'STSDU19703011512', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('11', 'A000008515C37D', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('12', '46HDU19801003573', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('13', 'cebe7bc3', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('14', '95803209150068I', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('15', '41845ab5', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('1569186870371864577', 'WP0NZG1BCN73Tlm', '1', '2022-08-03 13:00:00', 1, NULL, NULL, NULL);
INSERT INTO `tb_stock_account` VALUES ('1569186870371864578', 'a08cad5', '1', '2022-08-03 13:00:00', 0, NULL, NULL, NULL);
INSERT INTO `tb_stock_account` VALUES ('1569186870438973441', 'NAB0220811028120', '1', '2022-08-03 13:00:00', 1, NULL, NULL, NULL);
INSERT INTO `tb_stock_account` VALUES ('1569186870438973442', '3JU5T18411005978', '1', '2022-08-03 13:00:00', 1, NULL, NULL, NULL);
INSERT INTO `tb_stock_account` VALUES ('1569186870438973443', 'FMLDU19B23033370', '1', '2022-08-03 13:00:00', 1, NULL, NULL, NULL);
INSERT INTO `tb_stock_account` VALUES ('1569186870506082305', 'F4GFGS79N742', '1', '2022-08-03 13:00:00', 1, NULL, NULL, NULL);
INSERT INTO `tb_stock_account` VALUES ('1569186870506082306', 'A000008E605bd0', '1', '2022-08-03 13:00:00', 1, NULL, NULL, NULL);
INSERT INTO `tb_stock_account` VALUES ('1569186870506082307', '9b53ef80b20', '1', '2022-08-03 13:00:00', 0, NULL, NULL, NULL);
INSERT INTO `tb_stock_account` VALUES ('1569186870506082308', '9b53ef80b21', '1', '2022-08-03 13:00:00', 0, NULL, NULL, NULL);
INSERT INTO `tb_stock_account` VALUES ('1569186870573191170', '9b53ef80c21', '1', '2022-08-03 13:00:00', 1, NULL, NULL, NULL);
INSERT INTO `tb_stock_account` VALUES ('1569186870573191171', '9b53ef80d21', '1', '2022-08-03 13:00:00', 1, NULL, NULL, NULL);
INSERT INTO `tb_stock_account` VALUES ('1569186870573191172', '9b53ef80b22', '1', '2022-08-03 13:00:00', 1, NULL, NULL, NULL);
INSERT INTO `tb_stock_account` VALUES ('1569186870573191173', 'FJH5T18805009816', '1', '2022-08-03 13:00:00', 1, NULL, NULL, NULL);
INSERT INTO `tb_stock_account` VALUES ('1569186870640300033', 'cdfe6c62', '1', '2022-08-03 13:00:00', 1, NULL, NULL, NULL);
INSERT INTO `tb_stock_account` VALUES ('1569186870640300034', 'd247c830', '1', '2022-08-03 13:00:00', 1, NULL, NULL, NULL);
INSERT INTO `tb_stock_account` VALUES ('16', '4lda7lkj9hba7d7l', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('17', '73322793', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('18', 'E6E0220723001011', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('19', 'FFMX8PHEJC6', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('2', '25518aa5', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('20', 'FD2Y11SGJCLY', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('21', 'A00000E51DAB2F', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('22', 'U8ENW18479', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('23', 'CLB0218502000656', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('3', 'KZYDZ9EYINKRGUS8', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('4', 'WQCDU19815000556', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('5', 'A00000D0C7BF37', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('6', 'F4GWPCBRJC6C', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('7', '85PVTWU8KVI7INUW', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('8', '9YE0218524003777', '1', '2022-08-01 09:00:00', 1, 1, 0, '初始库存');
INSERT INTO `tb_stock_account` VALUES ('9', '2FD0221303041019', '1', '2022-08-01 09:00:00', 0, 1, 0, '初始库存');
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
  CONSTRAINT `FK_employee` FOREIGN KEY (`employee_id`) 
  REFERENCES `tb_employee` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_receipt` FOREIGN KEY (`receipt_id`) 
  REFERENCES `tb_receipt` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) 

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
  CONSTRAINT `FK_money_taking_employee` FOREIGN KEY (`employee_id`) 
  REFERENCES `tb_employee` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) 

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
  CONSTRAINT `FK_cashier` FOREIGN KEY (`cashier`)
  REFERENCES `tb_employee` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_seller` FOREIGN KEY (`seller`)
  REFERENCES `tb_employee` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) 

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
  CONSTRAINT `PK_prodcut` FOREIGN KEY (`product_id`) 
  REFERENCES `tb_product` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `PK_receipt` FOREIGN KEY (`receipt_id`) 
  REFERENCES `tb_receipt` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) 

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
  CONSTRAINT `FK_stock_employee` FOREIGN KEY (`employee_id`) 
  REFERENCES `tb_employee` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_stock_product` FOREIGN KEY (`product_id`) 
  REFERENCES `tb_product` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) 

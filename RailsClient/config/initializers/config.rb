$SYNC_HOST = 'http://192.168.1.109:3000'
$OPEN_SYN_LOCK= false

#用於匹配唯一嗎和零件數量的正則表達式
$REG_PACKAGE_ID = /^WI\d*$/
$FILTER_PACKAGE_QUANTITY =/\d+(?:\.\d+)?/
$REG_PACKAGE_QUANTITY = /^Q? ?\d*\.?\d*$/

<?

require_once "Loader.php";

$receipt_id = 26662020; // one digital transaction
$receipt = EtsyORM::getFinder('Receipt')->find($receipt_id);
print $receipt;

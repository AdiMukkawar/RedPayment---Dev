@isTest
public class HexUtil_Test 
{
    @isTest
    public static void testHexUtil()
    {
        String testData = 'Test Data';
        Blob data = Blob.valueOf(testData);
        Integer size = data.size();
        HexUtil.CRC32Table(data);
        String hexStr = 'Test Hex String';
        //HexUtil.CRC32Table(hexStr);
        String hexStr1 = 'Test Hex String';
        HexUtil.hexToIntLE(hexStr1);
        Integer decNumber = 100;
        HexUtil.intToHexLE(decNumber, size);
    }
}
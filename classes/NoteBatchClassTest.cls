@isTest 
public class NoteBatchClassTest {
    static testMethod void testMethod1(){
        List<Note> listNotes = new List<Note>();
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Oppty record 1';
        opp1.StageName = 'App Sent';
        opp1.CloseDate = date.today();
        insert opp1;
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Test Oppty record 1';
        opp2.StageName = 'App Sent';
        opp2.CloseDate = date.today() ;
        insert opp2;
        
        for(Integer i=0 ;i <10;i++){
            Note noteRecord = new Note();
            noteRecord.Title ='UW';
            noteRecord.ParentId = opp1.Id;
            noteRecord.Body = 'UW body';
            opp1.CloseDate = System.today() ;
            listNotes.add(noteRecord);
        }
        
        for(Integer i=0 ;i <10;i++){
            Note noteRecord = new Note();
            noteRecord.Title ='UW';
            noteRecord.ParentId = opp2.Id;
            noteRecord.Body = 'UW body';
            listNotes.add(noteRecord);
        }
        
        for(Integer i=0 ;i <20;i++){
            Note noteRecord1 = new Note();
            noteRecord1.Title ='Operations';
            noteRecord1.Body ='Operations';
            noteRecord1.ParentId = opp2.Id;
            listNotes.add(noteRecord1);
        }
        
        insert listNotes;
        
        Test.startTest();

            NoteBatchClass obj = new NoteBatchClass();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}
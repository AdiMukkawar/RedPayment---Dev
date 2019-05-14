global class NoteBatchClass implements Database.Batchable<sObject>{
    
    Map <Id, List<String>> noteMap = new Map <Id, List<String>>();
    List <String> noteList = new List <String>();
    List <Note> notesInsert = new List <Note>();
    Note noteRecord = new Note();
    
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
        String uwDoc = 'UW';
        string query = 'SELECT ID, ParentId, Body, Title from Note WHERE Title =\'' + uwDoc+ '\'';
        system.debug('query >>'+query);
        return Database.getQueryLocator(query);
    }
  
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<Note>scope){
        for(Note noteRec: scope){
            if(noteRec.ParentId.getSObjectType().getDescribe().getName() == 'Opportunity'){
                if(noteMap.containsKey(noteRec.ParentId)){
                    noteList.add(noteRec.Body);
                    noteMap.put(noteRec.ParentId, noteList);
                }else{
                    noteList = new List <String>();
                    noteList.add(noteRec.Body);
                    noteMap.put(noteRec.ParentId, noteList);
                }
            }
        }
        if(noteMap.size()>0){
            for(Id key : noteMap.keySet()){
                noteRecord = new Note();
                noteRecord.ParentId = key;
                noteRecord.Body = String.valueOf(noteMap.get(key));
                noteRecord.Title = 'Internal UW Notes';
                notesInsert.add(noteRecord);
            }
        }
        
        if(!notesInsert.isEmpty()){
            system.debug('notesInsert >>'+notesInsert);
            database.insert(notesInsert, false);
        }
        
        if(scope.size()>0){
            delete scope;
        }
        
   }
 
   global void finish(Database.BatchableContext BC){
        
   }
}
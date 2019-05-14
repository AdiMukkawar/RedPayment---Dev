trigger NoteTrigger on Note (before insert) {
    
    Map <Id, List<String>> noteMap = new Map <Id, List<String>>();
    Map<Id,Boolean> opportunityPassed = new Map<Id,Boolean>();
    List <String> noteList = new List <String>();
    String newBody;
    
    system.debug('Outside HelperClass.firstRun---->'+HelperClass.firstRun);
    if(HelperClass.firstRun){
        system.debug('In HelperClass.firstRun');
        if(Trigger.isBefore && Trigger.isInsert){
            HelperClass.firstRun=false;
            for(Note noteRec : Trigger.New){
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
                opportunityPassed.put(noteRec.ParentId,false);
            }
            system.debug('noteMap >>'+noteMap);
            system.debug('opportunityPassed >>'+opportunityPassed);
            for(Note noteRec : Trigger.New){
                if(!opportunityPassed.get(noteRec.ParentId)){
                    noteRec.body = String.valueOf(noteMap.get(noteRec.ParentId));
                    system.debug('noteRec.body >>'+noteRec.body);
                    opportunityPassed.put(noteRec.ParentId,true);
                }else{
                    //noteRec.addError('Already inserted');
                }
            }
        }
    }
}
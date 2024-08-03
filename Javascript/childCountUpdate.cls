trigger on opportunity (after insert){
    set<id> accountIdSet= new set<id>()
    for(opportunity op:(list<opportunity>)trigger.new())
    {
        accountIdSet.add(op.accountId);
    }
    list<AggregateResult> accountData = [select count(id),accountId from opportunity where accountId IN:accountIdSet group by accountId];
    list<account> accountsToUpdate = new list<account>();
    for(AggregateResult ac:accountData){
        accountData.add(new account(id=ac.get('accountId'),childCount = ac.get('exp0')));
    }
    if(!accountsToUpdate.isEmpty()){
        update accountsToUpdate;
    }
}
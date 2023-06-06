public with sharing class ViewingRecordsOnMobileHelper {

    @AuraEnabled(cacheable=true)
    public static List<ShiftWrapper> getShiftsList(String userId){
        List<ShiftWrapper> wrapperListToReturn = new List<ShiftWrapper>();
        Datetime currentDatetime = DateTime.newInstance(system.today(), Time.newInstance(0, 0, 0, 0));
        Datetime after7DaysDatetime = DateTime.newInstance(system.today().addDays(7), Time.newInstance(23, 59, 0, 0));
        List<Shift> shiftListToResturn = [SELECT Id, ShiftNumber, StartTime, EndTime, Status, Local_Start_Time__c, Local_End_Time__c FROM Shift WHERE ServiceResource.RelatedRecordId =: userId AND StartTime >=: currentDatetime AND StartTime <=: after7DaysDatetime AND Status = 'Confirmed' ORDER BY StartTime ASC];
        for(Shift shiftRec : shiftListToResturn){
            ShiftWrapper shiftWrap = new ShiftWrapper();
            shiftWrap.id = shiftRec.Id;
            shiftWrap.shiftNumber = shiftRec.ShiftNumber;
            shiftWrap.status = shiftRec.Status;
            shiftWrap.startDate = convertDateTimeFormat(shiftRec.StartTime);
            shiftWrap.endDate = convertDateTimeFormat(shiftRec.EndTime);
            wrapperListToReturn.add(shiftWrap);
        }
        return wrapperListToReturn;
    }

    public static String convertDateTimeFormat(Datetime dateToFormat){
        String formatedDatetime = monthOfYear.get(dateToFormat.month()) + ' ' + String.valueOf(dateToFormat.day()) + ', ' + String.valueOf(dateToFormat.year()) + ' ';
        if(dateToFormat.hour() > 12){
            formatedDatetime = formatedDatetime + String.valueOf(dateToFormat.hour() - 12) + ':' + (String.valueOf(dateToFormat.minute()).length() == 1 ? '0' + String.valueOf(dateToFormat.minute()) : String.valueOf(dateToFormat.minute()));
        }
        else{
            formatedDatetime = formatedDatetime + String.valueOf(dateToFormat.hour()) + ':' + (String.valueOf(dateToFormat.minute()).length() == 1 ? '0' + String.valueOf(dateToFormat.minute()) : String.valueOf(dateToFormat.minute()));
        }
        if(dateToFormat.hour() > 11){
            formatedDatetime = formatedDatetime + ' PM';
        }
        else{
            formatedDatetime = formatedDatetime + ' AM';
        }
		return formatedDatetime;
    }

    public class ShiftWrapper{
        @AuraEnabled
        public String id {get; set;}
        @AuraEnabled
        public String startDate {get; set;}
        @AuraEnabled
        public String endDate {get; set;}
        @AuraEnabled
        public String shiftNumber {get; set;} 
        @AuraEnabled
        public String status {get; set;} 
    }
}
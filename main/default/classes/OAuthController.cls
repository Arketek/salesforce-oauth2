public with sharing class OAuthController 
{
    @AuraEnabled
    public static Boolean save(string oAuthName, Map<String, Object> params)
    {
        try 
        {
            OAuth2__c oAuth = getNewestOAuthByName(oAuthName);
            System.debug('oAuth: ' + oAuth);

            if (oAuth == null)
            {
                oAuth = new OAuth2__c(); 
                oAuth.Name = oAuthName;
            }

            // Make them custom labels - maybe
            oAuth.Client_Id__c = (string) params.get('clientId');
            oAuth.Client_Secret__c = (string) params.get('clientSecret');

            upsert oAuth;
        } 
        catch (AuraHandledException e) 
        {
            throw new AuraHandledException(e.getMessage());
        }

        return true;
    }

    @AuraEnabled
    public static OAuth2__c getNewestOAuthByName(string oAuthName)
    {
        OAuth2__c oAuth;

        try 
        {
            oAuth = 
            [
                SELECT
                    Client_Id__c,
                    Client_Secret__c,
                    Expires_In__c,
                    Access_Token__c
                FROM OAuth2__c 
                WHERE Name =: oAuthName 
                ORDER BY CreatedDate DESC
                LIMIT 1
            ];
        } 
        catch (Exception e) 
        {
            return null;
        } 
        
        return oAuth;
    }
}

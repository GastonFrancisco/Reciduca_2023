public with sharing class BoletinDataService {

    @AuraEnabled(Cacheable=true)
    public static List<Calificacion__c> getCalificaciones(String boletinId) {
        List<Calificacion__c> listaDeCalificaciones = [SELECT Id, Materia__r.Name, Primer_trimestre__c, Segundo_trimestre__c, Tercer_trimestre__c, Final__c, Estado__c FROM Calificacion__c WHERE Boletin__c = :boletinId];
        return listaDeCalificaciones;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Inasistencia__c> getInasistencias(String boletinId) {
        List<Inasistencia__c> listaDeInasistencias = [SELECT Id, Primer_trimestre__c, Segundo_trimestre__c, Tercer_trimestre__c, Boletin__c, Acumulado_Anual__c FROM Inasistencia__c
                                                      WHERE Boletin__c = :boletinId];
        return listaDeInasistencias;
    }

    @AuraEnabled(Cacheable=true)
    public static Boletin__c getCapacidades(Id recordId) {
        return [SELECT
                AAAPE__c, AAAPEForm__c,
                CPE__c, CPEForm__c,
                AyCPE__c, AyCPEForm__c,
                PCPE__c, PCPEForm__c,
                OyPPE__c, OyPPEForm__c,
                TcOPE__c, TcOPEForm__c,
                CAPE__c, CAPEForm__c,
                AAASE__c, AAASEForm__c,
                CSE__c, CSEForm__c,
                AyCSE__c, AyCSEForm__c,
                PCSE__c, PCSEForm__c,
                OYPSE__c, OyPSEForm__c,
                TcOSE__c, TcOSEForm__c,
                CASE__c, CASEForm__c,
                Eval1_completa__c
                FROM Boletin__c
                WHERE Id = :recordId
                LIMIT 1
                ];
    }
    
    @AuraEnabled
    public static List<Calificacion__c> getListCalificaciones(List<ID> boletinIdList) {
        List<Calificacion__c> listaDeCalificaciones = [SELECT Id, Materia__r.Name, Primer_trimestre__c, Segundo_trimestre__c, Tercer_trimestre__c, Final__c, Boletin__c, Boletin__r.Alumno__c FROM Calificacion__c
                                                       WHERE Boletin__c IN :boletinIdList];
        return listaDeCalificaciones;
    }
    
    @AuraEnabled
    public static List<Inasistencia__c> getListInasistencias(List<ID> boletinIdList) {
        List<Inasistencia__c> listaDeInasistencias = [SELECT Id, Primer_trimestre__c, Segundo_trimestre__c, Tercer_trimestre__c, Boletin__r.Alumno__c, Acumulado_Anual__c FROM Inasistencia__c
                                                      WHERE Boletin__c IN :boletinIdList];
        return listaDeInasistencias;
    }

    @AuraEnabled
    public static String updateCalificacion(List<Calificacion__c> data) {
        try {
            update data;
            return 'Boletín actualizado';
        }
        catch(exception error) {
            return error.getMessage();
        }
        
    }

    @AuraEnabled
    public static String updateInasistencia(List<Inasistencia__c> data) {
        try {
            update data;
            return 'Boletín actualizado';
        }
        catch(exception error) {
            return error.getMessage();
        }
    }

    @AuraEnabled
    public static String updateCapacidades(String data) {
        try {
            Boletin__c boletin = (Boletin__c)JSON.deserializeStrict(data, Boletin__c.class);
            update boletin;
            return 'Boletín actualizado';
        }
        catch(exception error) {
            return error.getMessage();
        }
    }
}
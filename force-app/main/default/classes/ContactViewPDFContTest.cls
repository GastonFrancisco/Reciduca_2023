@isTest
public with sharing class ContactViewPDFContTest 
{
    @isTest
    public static void testContactNPSPBecariosNivelCero()
    {
        test.startTest();
        
        Contact alumno = setupAlumno('Técnica', '5°');
        Boletin__c boletin = [SELECT Id FROM Boletin__c WHERE Alumno__c =: alumno.Id];

        Inasistencia__c inasistencia = new Inasistencia__c();
        inasistencia.Boletin__c = boletin.Id;
        insert inasistencia;

        Programa__c prog = TestDataFactory.createProgramaNivelCero('programa nivel 0');
        Pertenencia_a_Programas__c pert = TestDataFactory.createPertenencia(alumno.Id, prog.Id);
        Seguimiento_Educativo__c seguimiento = TestDataFactory.createSeguimiento(alumno.Id, prog.Id);
        List<Asistencia_a_Espacio_Educativo__c> asistenciaEspacio = TestDataFactory.createAsistenciaEspacios(boletin.Id);

        ApexPages.StandardController sc = new ApexPages.StandardController(alumno);
        ContactViewPDFController controller = new ContactViewPDFController(sc);
        
        test.stopTest();
        
        System.assertNotEquals(controller.resultList[0].boletin,null);
        System.assertNotEquals(controller.resultList[0].listaDeCalificaciones,null);
        System.assertNotEquals(controller.resultList[0].listaDeInasistencias,null);
        System.assertNotEquals(controller.resultList[0].programa,null);
        System.assertNotEquals(controller.resultList[0].ImagenDeAlumno,null);
        System.assertNotEquals(controller.resultList[0].thecontact,null);
        System.assertNotEquals(controller.resultList[0].capacidades,null);
        System.assertNotEquals(controller.resultList[0].actividadesPrograma, null);
        System.assertNotEquals(controller.resultList[0].asistenciaAEspacios, null);
        System.assertEquals(controller.boleano, false);
    }

    @isTest
    public static void testContactNPSPBecariosNivelUno()
    {
        test.startTest();
        
        Contact alumno = setupAlumno('Técnica', '6°');
        Boletin__c boletin = [SELECT Id FROM Boletin__c WHERE Alumno__c =: alumno.Id];

        Inasistencia__c inasistencia = new Inasistencia__c();
        inasistencia.Boletin__c = boletin.Id;
        insert inasistencia;

        Programa__c prog = TestDataFactory.createProgramaNivelUno('programa nivel 1');
        Pertenencia_a_Programas__c pert = TestDataFactory.createPertenencia(alumno.Id, prog.Id);
        Seguimiento_Educativo__c seguimiento = TestDataFactory.createSeguimiento(alumno.Id, prog.Id);
        List<Asistencia_a_Espacio_Educativo__c> asistenciaEspacio = TestDataFactory.createAsistenciaEspacios(boletin.Id);

        ApexPages.StandardController sc = new ApexPages.StandardController(alumno);
        ContactViewPDFController controller = new ContactViewPDFController(sc);
        
        test.stopTest();
        
        System.assertNotEquals(controller.resultList[0].boletin,null);
        System.assertNotEquals(controller.resultList[0].listaDeCalificaciones,null);
        System.assertNotEquals(controller.resultList[0].listaDeInasistencias,null);
        System.assertNotEquals(controller.resultList[0].programa,null);
        System.assertNotEquals(controller.resultList[0].ImagenDeAlumno,null);
        System.assertNotEquals(controller.resultList[0].thecontact,null);
        System.assertNotEquals(controller.resultList[0].capacidades,null);
        System.assertNotEquals(controller.resultList[0].actividadesPrograma, null);
        System.assertNotEquals(controller.resultList[0].asistenciaAEspacios, null);
        System.assertEquals(controller.boleano, false);
    }

    @isTest
    public static void testContactNPSPBecariosNivelDosOrientada()
    {
        test.startTest();
        
        Contact alumno = setupAlumno('Orientada', '6°');
        Boletin__c boletin = [SELECT Id FROM Boletin__c WHERE Alumno__c =: alumno.Id];

        Inasistencia__c inasistencia = new Inasistencia__c();
        inasistencia.Boletin__c = boletin.Id;
        insert inasistencia;

        Programa__c prog = TestDataFactory.createProgramaNivelDos('programa nivel 2');
        Pertenencia_a_Programas__c pert = TestDataFactory.createPertenencia(alumno.Id, prog.Id);
        Seguimiento_Educativo__c seguimiento = TestDataFactory.createSeguimiento(alumno.Id, prog.Id);
        List<Asistencia_a_Espacio_Educativo__c> asistenciaEspacio = TestDataFactory.createAsistenciaEspacios(boletin.Id);

        ApexPages.StandardController sc = new ApexPages.StandardController(alumno);
        ContactViewPDFController controller = new ContactViewPDFController(sc);
        
        test.stopTest();
        
        System.assertNotEquals(controller.resultList[0].boletin,null);
        System.assertNotEquals(controller.resultList[0].listaDeCalificaciones,null);
        System.assertNotEquals(controller.resultList[0].listaDeInasistencias,null);
        System.assertNotEquals(controller.resultList[0].programa,null);
        System.assertNotEquals(controller.resultList[0].ImagenDeAlumno,null);
        System.assertNotEquals(controller.resultList[0].thecontact,null);
        System.assertNotEquals(controller.resultList[0].capacidades,null);
        System.assertNotEquals(controller.resultList[0].actividadesPrograma, null);
        System.assertNotEquals(controller.resultList[0].asistenciaAEspacios, null);
        System.assertEquals(controller.boleano, false);
    }

    @isTest
    public static void testContactNPSPBecariosNivelDosTecnica()
    {
        test.startTest();
        
        Contact alumno = setupAlumno('Técnica', '7°');
        Boletin__c boletin = [SELECT Id FROM Boletin__c WHERE Alumno__c =: alumno.Id];

        Inasistencia__c inasistencia = new Inasistencia__c();
        inasistencia.Boletin__c = boletin.Id;
        insert inasistencia;

        Programa__c prog = TestDataFactory.createProgramaNivelDos('programa nivel 2');
        Pertenencia_a_Programas__c pert = TestDataFactory.createPertenencia(alumno.Id, prog.Id);
        Seguimiento_Educativo__c seguimiento = TestDataFactory.createSeguimiento(alumno.Id, prog.Id);
        List<Asistencia_a_Espacio_Educativo__c> asistenciaEspacio = TestDataFactory.createAsistenciaEspacios(boletin.Id);

        ApexPages.StandardController sc = new ApexPages.StandardController(alumno);
        ContactViewPDFController controller = new ContactViewPDFController(sc);
        
        test.stopTest();
        
        System.assertNotEquals(controller.resultList[0].boletin,null);
        System.assertNotEquals(controller.resultList[0].listaDeCalificaciones,null);
        System.assertNotEquals(controller.resultList[0].listaDeInasistencias,null);
        System.assertNotEquals(controller.resultList[0].programa,null);
        System.assertNotEquals(controller.resultList[0].ImagenDeAlumno,null);
        System.assertNotEquals(controller.resultList[0].thecontact,null);
        System.assertNotEquals(controller.resultList[0].capacidades,null);
        System.assertNotEquals(controller.resultList[0].actividadesPrograma, null);
        System.assertNotEquals(controller.resultList[0].asistenciaAEspacios, null);
        System.assertEquals(controller.boleano, false);
    }

    @isTest
    public static void testContactNPSPBecariosNivelCeroTecnica()
    {
        test.startTest();
        
        Contact alumno = setupAlumno('Técnica', '5°');
        Boletin__c boletin = [SELECT Id FROM Boletin__c WHERE Alumno__c =: alumno.Id];

        Inasistencia__c inasistencia = new Inasistencia__c();
        inasistencia.Boletin__c = boletin.Id;
        insert inasistencia;

        Programa__c prog = TestDataFactory.createProgramaNivelDos('programa nivel 0');
        Pertenencia_a_Programas__c pert = TestDataFactory.createPertenenciaInactiva(alumno.Id, prog.Id);
        Seguimiento_Educativo__c seguimiento = TestDataFactory.createSeguimiento(alumno.Id, prog.Id);
        List<Asistencia_a_Espacio_Educativo__c> asistenciaEspacio = TestDataFactory.createAsistenciaEspacios(boletin.Id);

        ApexPages.StandardController sc = new ApexPages.StandardController(alumno);
        ContactViewPDFController controller = new ContactViewPDFController(sc);
        
        test.stopTest();
        
        System.assertNotEquals(controller.boleano, false);
    }

    @isTest
    public static void testContactNPSPGenerales()
    {
        test.startTest();
        
        Contact alumno = setupAlumno('Técnica', '6°'); 
        Contact padrino = [SELECT Id FROM Contact WHERE Id =: alumno.Padrino__c];

        Programa__c prog = TestDataFactory.createProgramaNivelUno('programa nivel 1');
        Pertenencia_a_Programas__c pert = TestDataFactory.createPertenencia(alumno.Id, prog.Id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(padrino);
        ContactViewPDFController controller = new ContactViewPDFController(sc);
        
        test.stopTest();
        
        System.assertNotEquals(controller.resultList[0].boletin,null);
        System.assertNotEquals(controller.resultList[0].listaDeCalificaciones,null);
        System.assertNotEquals(controller.resultList[0].listaDeInasistencias,null);
        System.assertNotEquals(controller.resultList[0].programa,null);
    }

    @isTest
    public static void testContactPDFEscuela()
    {
        test.startTest();
        
        Contact alumno = setupAlumno('Técnica', '6°'); 
        Account escuela = [SELECT Id FROM Account WHERE Id =: alumno.npsp__Primary_Affiliation__c];

        Programa__c prog = TestDataFactory.createProgramaNivelUno('programa nivel 1');
        Pertenencia_a_Programas__c pert = TestDataFactory.createPertenencia(alumno.Id, prog.Id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(escuela);
        ContactViewPDFController controller = new ContactViewPDFController(sc);
        
        test.stopTest();
        
        System.assertNotEquals(controller.resultList[0].boletin,null);
        System.assertNotEquals(controller.resultList[0].listaDeCalificaciones,null);
        System.assertNotEquals(controller.resultList[0].listaDeInasistencias,null);
        System.assertNotEquals(controller.resultList[0].programa,null);
    }

    //Helper creacion alumno
    private static Contact setupAlumno(String orientacion, String anioQueCursa) {
        DateTime myDateTime = DateTime.now();
        
        //creación de 3 materias
        List<Materia__c> listMaterias = new List<Materia__c>();
        for (Integer i = 0; i < 3; i++) {
            Materia__c materia = new Materia__c(Name='Materia '+ i + myDateTime.millisecond());
            listMaterias.add(materia);
        }
        insert listMaterias;

        //creación de escuela
        id schemaTypeEscuela = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Escuela').getRecordTypeId();
        Account esc = new Account(Name='Escuelita', Modalidad__c = orientacion, RecordTypeId=schemaTypeEscuela);
        insert esc;

        //creación de plan de estudios, con lookup a las materias y la escuela
        List<Plan_de_estudios__c> listPlanEstudio = new List<Plan_de_estudios__c>();
        for (Integer i = 0; i < 3; i++) {
           Plan_de_estudios__c planEstudio = new Plan_de_estudios__c();
           planEstudio.Anio_en_curso__c = anioQueCursa;
           planEstudio.Escuela__c = esc.Id;
           planEstudio.Materia__c = listMaterias[i].Id;
           listPlanEstudio.add(planEstudio);
        }
        insert listPlanEstudio;
        
        //creación de padrino
        id schemaTypeIdPadrino = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('NPSP Contactos Generales').getRecordTypeId();
        Contact padrino = new Contact(
            FirstName = 'Nombre'+myDateTime.millisecond(),
            LastName='Apellido'+myDateTime.millisecond(), 
            RecordTypeId=schemaTypeIdPadrino, 
            Sexo__c='Masculino'
        );
        insert padrino;

        //creación de alumno con padrino asignado
        id schemaTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('NPSP Becarios').getRecordTypeId();
        Contact alumno = new Contact(
            FirstName = 'Nombre'+myDateTime.millisecond(),
            LastName = 'Apellido'+myDateTime.millisecond(), 
            RecordTypeId = schemaTypeId, 
            Sexo__c = 'Masculino',
            A_o_de_Ingreso_a_Reciduca__c = 2003, 
            A_o_que_cursa__c = anioQueCursa, 
            npsp__Primary_Affiliation__c = esc.Id,
            Padrino__c = padrino.Id
            );
        insert alumno;

        ContentVersion imgTest = new ContentVersion();
        imgTest.FirstPublishLocationId = alumno.Id;
        imgTest.Title = 'Test Image';
        imgTest.ContentUrl = 'image test url';
        insert imgTest;

        return alumno;

    }
}
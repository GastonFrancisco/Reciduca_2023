@isTest
public with sharing class BoletinDataServiceTest 
{
    @isTest
    public static void testGetCalificaciones()
    {
        test.startTest();
        
        // crea un boletín con tres calificaciones
        Contact alumno = setupAlumno();
        Boletin__c boletin = [SELECT Id FROM Boletin__c WHERE Alumno__c =: alumno.Id];
        List<Calificacion__c> califList = BoletinDataService.getCalificaciones(boletin.Id);
        
        test.stopTest();
        
        System.assertEquals(califList.size(), 3);
    }

    @isTest
    public static void testGetInasistencias()
    {
        test.startTest();

        // crea un boletín con una inasistencia
        Contact alumno = setupAlumno();
        Boletin__c boletin = [SELECT Id FROM Boletin__c WHERE Alumno__c =: alumno.Id];

        List<Inasistencia__c> inasList = BoletinDataService.getInasistencias(boletin.Id);
      
        test.stopTest();

        System.assertEquals(inasList.size(), 1);

    }

    @isTest
    public static void testGetCapacidades()
    {
        test.startTest();

        // crea un boletín con una inasistencia
        Contact alumno = setupAlumno();
        Boletin__c boletin = [SELECT Id FROM Boletin__c WHERE Alumno__c =: alumno.Id];
        
        Boletin__c boletinWithFields = BoletinDataService.getCapacidades(boletin.Id);
      
        test.stopTest();

        System.assertEquals(boletinWithFields.AAAPE__c, null);

    }

    @isTest
    public static void testGetListCalificaciones()
    {
        test.startTest();

        
        //crea tres alumnos y por cada uno crea un boletin
        List<Contact> alumnos = setupMultiAlumno();
        List<Id> alumnosIds = new List<Id>();
        for(Contact alumno : alumnos){
            alumnosIds.add(alumno.Id);
        }
        
        List<Boletin__c> boletines =[SELECT Id FROM Boletin__c WHERE Alumno__c IN: alumnosIds];

        List<Id> listBoletinIds = new List<Id>();
        for(Boletin__c boletin : boletines){
            listBoletinIds.add(boletin.Id);
        }
        
        //Cada boletín tiene tres calificaciones, por lo que debe haber nueve calificaciones en total
        List<Calificacion__c> califList = BoletinDataService.getListCalificaciones(listBoletinIds);
		test.stopTest();

        System.assertEquals(califList.size(), 9);

    }

    @isTest
    public static void testGetListInasistencias()
    {
        
    	test.startTest();
        
        
        //crea tres alumnos y por cada uno crea un boletin
        List<Contact> alumnos = setupMultiAlumno();
        List<Id> alumnosIds = new List<Id>();
        for(Contact alumno : alumnos){
            alumnosIds.add(alumno.Id);
        }
        
        List<Boletin__c> boletines =[SELECT Id FROM Boletin__c WHERE Alumno__c IN: alumnosIds];
        List<Id> listBoletinIds = new List<Id>();
        for(Boletin__c boletin : boletines){
            listBoletinIds.add(boletin.Id);
        }
        
        //Cada boletín tiene una inasistencia, por lo que debe haber tres inasistencias en total
        List<Inasistencia__c> inasList = BoletinDataService.getListInasistencias(listboletinIds);

        test.stopTest();
        System.assertEquals(inasList.size(), 3);

    }

    @isTest
    public static void testUpdateCalificacion()
    {
        test.startTest();

        // crea un boletín con tres calificaciones
        Contact alumno = setupAlumno();
        Boletin__c boletin = [SELECT Id FROM Boletin__c WHERE Alumno__c =: alumno.Id];


        //modificamos las calificaciones creadas
        List<Calificacion__c> listCalificacion = [SELECT Id FROM Calificacion__c WHERE Boletin__c =: boletin.Id];
        listCalificacion[0].Primer_trimestre__c = 7;
        listCalificacion[1].Segundo_trimestre__c = 8;
        listCalificacion[2].Tercer_trimestre__c = 9;

        //realizamos el update a través del método updateCalificacion()
        BoletinDataService.updateCalificacion(listCalificacion);

        test.stopTest();
        System.assertEquals([SELECT COUNT() FROM Calificacion__c
                             WHERE Boletin__c =: boletin.Id
                             AND (Primer_trimestre__c = 7 OR Segundo_trimestre__c = 8 OR Tercer_trimestre__c = 9)],
                           3);
    }

    @isTest
    public static void testUpdateCalificacionWithError()
    {
        test.startTest();

        // crea un boletín con tres calificaciones
        Contact alumno = setupAlumno();
        Boletin__c boletin = [SELECT Id FROM Boletin__c WHERE Alumno__c =: alumno.Id];


        //modificamos las calificaciones creadas una mayor a 10 para obtener un error
        List<Calificacion__c> listCalificacion = [SELECT Id FROM Calificacion__c WHERE Boletin__c =: boletin.Id];
        listCalificacion[0].Primer_trimestre__c = 13;
        listCalificacion[1].Segundo_trimestre__c = 8;
        listCalificacion[2].Tercer_trimestre__c = 9;

        //realizamos el update a través del método updateCalificacion() y recibimos un mensaje de error
        String errorResult = BoletinDataService.updateCalificacion(listCalificacion);

        test.stopTest();
        System.assertNotEquals(errorResult, null);
    }

    @isTest
    public static void testUpdateInasistencia()
    {
        test.startTest();

        // crea un boletín y un registro de Inasistencia__c
        Contact alumno = setupAlumno();
        Boletin__c boletin = [SELECT Id FROM Boletin__c WHERE Alumno__c =: alumno.Id];

        Inasistencia__c inasistencia = new Inasistencia__c();
        inasistencia.Boletin__c = boletin.Id;
        insert inasistencia;

        //modificamos la inasistencia creada
        List<Inasistencia__c> inasistencias = [SELECT Id FROM Inasistencia__c WHERE Boletin__c =: boletin.Id];
        inasistencias[0].Primer_trimestre__c = 1;
        inasistencias[0].Segundo_trimestre__c = 2;
        inasistencias[0].Tercer_trimestre__c = 3;

        //realizamos el update a través del método updateInasistencia()
        BoletinDataService.updateInasistencia(inasistencias);

        test.stopTest();
        System.assertEquals([SELECT COUNT() FROM Inasistencia__c
                             WHERE Boletin__c =: boletin.Id
                             AND Primer_trimestre__c = 1 AND Segundo_trimestre__c = 2 AND Tercer_trimestre__c = 3],
                           1); 
    }
    @isTest
    public static void testUpdateInasistenciaWithError()
    {
        test.startTest();

        // crea un boletín y un registro de Inasistencia__c
        Contact alumno = setupAlumno();
        Boletin__c boletin = [SELECT Id FROM Boletin__c WHERE Alumno__c =: alumno.Id];

        //modificamos la inasistencia creada con un valor negativo para obtener un error
        List<Inasistencia__c> inasistencias = [SELECT Id FROM Inasistencia__c WHERE Boletin__c =: boletin.Id];
        inasistencias[0].Primer_trimestre__c = -1;
        inasistencias[0].Segundo_trimestre__c = 2;
        inasistencias[0].Tercer_trimestre__c = 3;

        //realizamos el update a través del método updateInasistencia()
        String errorResult = BoletinDataService.updateInasistencia(inasistencias);

        test.stopTest();
        System.assertNotEquals(errorResult, null);
    }

    @isTest
    public static void testUpdateCapacidades()
    {
        test.startTest();

        // crea un boletín
        Contact alumno = setupAlumno();
        Boletin__c boletin = [SELECT Id FROM Boletin__c WHERE Alumno__c =: alumno.Id];

        //modificamos el boletín cread
        boletin.PCPE__c = 'Excelente';
        String jsonString = JSON.serialize(boletin);

        //realizamos el update a través del método updateCapacidades()
        BoletinDataService.updateCapacidades(jsonString);

        test.stopTest();
        System.assertEquals([SELECT COUNT() FROM Boletin__c
                             WHERE Id = :boletin.Id
                             AND PCPE__c = 'Excelente'],
                           1);
    }

    @isTest
    public static void testUpdateCapacidadesWithError()
    {
        test.startTest();

        // crea un boletín
        Contact alumno = setupAlumno();
        Boletin__c boletin = [SELECT Id FROM Boletin__c WHERE Alumno__c =: alumno.Id];

        //modificamos el boletín cread
        boletin.PCPE__c = 'Excelentesss';
        String jsonString = JSON.serialize(boletin);

        //realizamos el update a través del método updateInasistencia()
        String errorResult = BoletinDataService.updateCapacidades(jsonString);

        test.stopTest();
        System.assertNotEquals(errorResult, null);
    }

    //Helper alumno
    private static Contact setupAlumno() {
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
        Account esc = new Account(Name='Escuelita', RecordTypeId=schemaTypeEscuela);
        insert esc;

        //creación de plan de estudios, con lookup a las materias y la escuela
        List<Plan_de_estudios__c> listPlanEstudio = new List<Plan_de_estudios__c>();
        for (Integer i = 0; i < 3; i++) {
           Plan_de_estudios__c planEstudio = new Plan_de_estudios__c();
           planEstudio.Anio_en_curso__c = '6°';
           planEstudio.Escuela__c = esc.Id;
           planEstudio.Materia__c = listMaterias[i].Id;
           listPlanEstudio.add(planEstudio);
        }
        insert listPlanEstudio;
        
        //creación de contacto
        id schemaTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('NPSP Becarios').getRecordTypeId();
        Contact alumno = new Contact(FirstName = 'Nombre'+myDateTime.millisecond(), LastName='Apellido'+myDateTime.millisecond(), RecordTypeId=schemaTypeId, Sexo__c='Masculino',
                             A_o_de_Ingreso_a_Reciduca__c=2003, A_o_que_cursa__c='6°', npsp__Primary_Affiliation__c=esc.Id);
        insert alumno;

        return alumno;

    }

    // Helper 3 alumnos
    private static List<Contact> setupMultiAlumno() {
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
        Account esc = new Account(Name='Escuelita', RecordTypeId=schemaTypeEscuela);
        insert esc;

        //creación de plan de estudios, con lookup a las materias y la escuela
        List<Plan_de_estudios__c> listPlanEstudio = new List<Plan_de_estudios__c>();
        for (Integer i = 0; i < 3; i++) {
           Plan_de_estudios__c planEstudio = new Plan_de_estudios__c();
           planEstudio.Anio_en_curso__c = '6°';
           planEstudio.Escuela__c = esc.Id;
           planEstudio.Materia__c = listMaterias[i].Id;
           listPlanEstudio.add(planEstudio);
        }
        insert listPlanEstudio;
        
        //creación de 3 contactos
        id schemaTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('NPSP Becarios').getRecordTypeId();
        
        List<Contact> alumnos = new List<Contact>();
        for( Integer i = 0; i < 3; i++){
            alumnos.add( new Contact(
                FirstName = 'Nombre'+myDateTime.millisecond(),
                LastName = 'Apellido'+myDateTime.millisecond(),
                RecordTypeId=schemaTypeId, 
                Sexo__c='Masculino',
                A_o_de_Ingreso_a_Reciduca__c=2003, 
                A_o_que_cursa__c='6°', npsp__Primary_Affiliation__c=esc.Id
            ));
        }
        
        insert alumnos;

        return alumnos;
    }
}
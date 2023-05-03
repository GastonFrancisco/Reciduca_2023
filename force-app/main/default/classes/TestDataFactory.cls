@isTest
public class TestDataFactory 
{
    
    public static Programa__c createProgramaNivelCero(String name)
    {
    	id cfc = Schema.SObjectType.Programa__c.getRecordTypeInfosByName().get('Programa Educativo').getRecordTypeId();

		Programa__c programa = new Programa__c(RecordTypeId=cfc, Name=name, N_0_Escuela_Tecnica__c = 'Manzana');
       
		insert programa;
        
        return programa;
    }

    public static Programa__c createProgramaNivelUno(String name)
    {
    	id cfc = Schema.SObjectType.Programa__c.getRecordTypeInfosByName().get('Programa Educativo').getRecordTypeId();

		Programa__c programa = new Programa__c(RecordTypeId=cfc, Name=name, N_1_Escuela_Tecnica_Orientada__c = 'Manzana');
       
		insert programa;
        
        return programa;
    }

    public static Programa__c createProgramaNivelDos(String name)
    {
    	id cfc = Schema.SObjectType.Programa__c.getRecordTypeInfosByName().get('Programa Educativo').getRecordTypeId();

		Programa__c programa = new Programa__c(RecordTypeId=cfc, Name=name, N_2_Escuela_Tecnica__c = 'Manzana', N_2_Escuela_Orientada__c = 'Manzana');
       
		insert programa;
        
        return programa;
    }
    
    public static Pertenencia_a_Programas__c createPertenencia(id idAlumno, id idPrograma)
    {
        Pertenencia_a_Programas__c pertenencia = new Pertenencia_a_Programas__c(Alumno__c=idAlumno,Programa__c=idPrograma, Estado__c='Activo');

		insert pertenencia;
        
        return pertenencia;
    }

    public static Pertenencia_a_Programas__c createPertenenciaInactiva(id idAlumno, id idPrograma)
    {
        Pertenencia_a_Programas__c pertenencia = new Pertenencia_a_Programas__c(Alumno__c=idAlumno,Programa__c=idPrograma, Estado__c='Inactivo');

		insert pertenencia;
        
        return pertenencia;
    }
    
    public static Seguimiento_Educativo__c createSeguimiento(id idAlumno, id idPrograma)
    {
    	Seguimiento_Educativo__c segEduc = new Seguimiento_Educativo__c(
            Alumno__c=idAlumno,
            Estado__c='Cursando 5° Año',
            Nro_de_Informe__c = '4',
            Programa__c=idPrograma,
            Cu_ntas__c=2,
            Fecha_de_Informe__c=Date.newInstance(2021, 2, 17),
            Cantidad_de_Materias_Previas__c=2
            );

		insert segEduc;
        
        return segEduc;
	}

    public static List<Asistencia_a_Espacio_Educativo__c> createAsistenciaEspacios(Id boletin)
    {
        List<Asistencia_a_Espacio_Educativo__c> asistenciaEspacio = new List<Asistencia_a_Espacio_Educativo__c>{ new Asistencia_a_Espacio_Educativo__c(Boletin__c = boletin, Mes__c = 'Mayo', Espacio_Educativo__c = 'Practica Educativa', Cantidad_de_Encuentros__c = 5, Encuentros_Asistidos__c = 5), new Asistencia_a_Espacio_Educativo__c(Boletin__c = boletin, Mes__c = 'Junio', Espacio_Educativo__c = 'Practica Educativa', Cantidad_de_Encuentros__c = 5, Encuentros_Asistidos__c = 5)};

		insert asistenciaEspacio;
        
        return asistenciaEspacio;
	}
    
}
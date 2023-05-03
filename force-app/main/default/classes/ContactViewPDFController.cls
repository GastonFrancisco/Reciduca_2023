public class ContactViewPDFController {

    private Id recordId;
    private Contact contacto {get;set;}
    public List<contactWrapper> resultList {get;set;}
    public Boolean boleano {get;set;}
    
    public ContactViewPDFController(ApexPages.StandardController controller) {
        resultList = new List<contactWrapper>();
        this.recordId = controller.getId();
        String sObjectName = this.recordId.getSobjectType().getDescribe().getName();
        List<Contact> becariosList = new List<Contact>();
        String condition = '';
        
        
        if(sObjectName == 'Account')
        {
            contacto = [SELECT Id, RecordType.Name FROM Contact WHERE npsp__Primary_Affiliation__c =:recordId LIMIT 1];
            condition = 'WHERE npsp__Primary_Affiliation__c = :recordId';
        }
        else if(sObjectName == 'Contact')
        {
            contacto = [SELECT Id, RecordType.Name FROM Contact WHERE id=: recordId LIMIT 1];
            
            if(contacto.RecordType.Name == 'NPSP Becarios')
            	condition = 'WHERE Id = :recordId';
            else if(contacto.RecordType.Name == 'NPSP Contactos Generales')
            	condition = 'WHERE Padrino__c = :recordId';            
        }
            
        String qr = 'SELECT Id, npsp__Primary_Affiliation__r.Modalidad__c, (select Id, CreatedDate, Alumno__c, Estado__c, Programa__r.Name, Programa__r.N_0_Escuela_Tecnica__c, Programa__r.N_1_Escuela_Tecnica_Orientada__c, Programa__r.N_2_Escuela_Orientada__c, Programa__r.N_2_Escuela_Tecnica__c from Pertenencias_a_Programas__r order by CreatedDate desc limit 1),(Select Id,Alumno__c, a_Espacio_de_Estudio__c, b_Capacitaciones__c, Tipo_de_Practica__c, c_Practica_Educativa__c,  c_Observaciones_Practica_Educativa__c, Practica_en_Empresa__c, d_Espacio_Desarrollo_Personal__c,Proyecto_CAS__c, a_Observaciones_Personales__c, Estado__c, Fecha_de_Informe__c, CreatedDate, Nro_de_Informe__c from Seguimientos_Educativos__r ORDER BY CreatedDate DESC LIMIT 1), (Select Id,Alumno__c,Alumno__r.Name, Alumno__r.Birthdate, Alumno__r.Edad__c, Alumno__r.npsp__Primary_Affiliation__r.Name,Alumno__r.Account.Name, Alumno__r.MailingCity, Anio_calendario__c, Cuatrimestral__c, Primer_Promedio__c, Segundo_Promedio__c, Tercer_Promedio__c, Final_Promedio__c, Esfuerzo__c,Observaciones_Esfuerzo__c, Observaciones_de_Inasistencia_a_Clase__c, Observaciones_Generales__c, AAAPE__c, AAAPEForm__c, CPE__c, CPEForm__c, AyCPE__c, AyCPEForm__c, PCPE__c, PCPEForm__c, OyPPE__c, OyPPEForm__c, TcOPE__c, TcOPEForm__c, CAPE__c, CAPEForm__c, AAASE__c, AAASEForm__c, CSE__c, CSEForm__c, AyCSE__c, AyCSEForm__c,PCSE__c, PCSEForm__c,OYPSE__c, OYPSEForm__c,TcOSE__c, TcOSEForm__c, CASE__c, CASEForm__c, Eval1_completa__c, Eval2_completa__c, Materias_Previas__c, CreatedDate FROM Boletines__r ORDER BY CreatedDate DESC LIMIT 1) FROM Contact ' + condition;
        becariosList = Database.query(qr);
        
        List<Id> becariosId = new List<Id>();
        List<Id> boletinesIds = new List<Id>();
        List<Seguimiento_Educativo__c> seguimientosList = new List<Seguimiento_Educativo__c>();
        List<Boletin__c> boletinesList = new List<Boletin__c>();
        List<Pertenencia_a_Programas__c> pertenenciaList = new List<Pertenencia_a_Programas__c>();
        
        Map<Id, List<List<String>>> capacidadesByAlumno = new  Map<Id, List<List<String>>>();

        Map<Id, Contact> alumnoById = new Map<Id, Contact>();
        Map<Id, Pertenencia_a_Programas__c> pertenenciasMap = new Map<Id, Pertenencia_a_Programas__c>();
        Map<Id, Seguimiento_Educativo__c> seguimientoMap = new Map<Id, Seguimiento_Educativo__c>();
        Map<Id, Boletin__c> boletinMap = new Map<Id, Boletin__c>();
        Map<Id, List<Inasistencia__c>> faltasMap = new Map<Id, List<Inasistencia__c>>();
        Map<Id, List<Calificacion__c>> calificacionesMap = new Map<Id, List<Calificacion__c>>();
        Map<Id, Id> IdImagenAlumnoByIdAlumno = new  Map<Id, Id>();
        Map<Id, List<List<String>>> inasistenciaAEspaciosByAlumno = new Map<Id, List<List<String>>>();

        Map<Id, String> actividadesProgramaMap = new Map<Id, String>();
        String modalidad = becariosList[0].npsp__Primary_Affiliation__r.Modalidad__c;
               
        for(Contact cont: becariosList){   
            becariosId.add(cont.Id);
            if(!alumnoById.containsKey(cont.Id)){
                alumnoById.put(cont.Id, cont);
            }
            //↓ Se podria poblar un mapa aca mismo usando 'cont.Seguimientos_Educativos__r[0]' porque en la query se limita a 1
            seguimientosList.addAll(cont.Seguimientos_Educativos__r);
            //↑ Esto podria ser reemplazado por esto ↓
/*             if(cont.Seguimientos_Educativos__r.size() > 0){
                seguimientoMap.put(cont.Id, cont.Seguimientos_Educativos__r[0]);
            } */

            if(cont.Pertenencias_a_Programas__r.size() > 0){
                pertenenciasMap.put(cont.Id, cont.Pertenencias_a_Programas__r[0]);
                Pertenencia_a_Programas__c p = cont.Pertenencias_a_Programas__r[0];
                String nombrePrograma = p.Programa__r.Name.toLowerCase();
                for(String name:  nombrePrograma.split(' ')){
                    System.debug(name);
                    if((name == '0' || name == 'cero' || name == 'n0') && modalidad == 'Técnica'){
                        actividadesProgramaMap.put(p.Alumno__c, p.Programa__r.N_0_Escuela_Tecnica__c);
                    } 
                    else if(name == '1' || name == 'i' || name == 'uno' || name == 'n1'){
                        actividadesProgramaMap.put(p.Alumno__c, p.Programa__r.N_1_Escuela_Tecnica_Orientada__c);
                    } 
                    else if(name == '2' || name == 'ii' || name == 'dos' || name == 'n2'){
                        if(modalidad == 'Técnica'){
                            actividadesProgramaMap.put(p.Alumno__c, p.Programa__r.N_2_Escuela_Tecnica__c);
                        }
                        else{
                            actividadesProgramaMap.put(p.Alumno__c, p.Programa__r.N_2_Escuela_Orientada__c);
                        }
                    } 
                }
            }
            // el else if agregaria el nombre del alumno en el caso de que no tenga una pertenencia a programa o no este activa

            boletinesIds.add(cont.Boletines__r[0].Id);
            boletinesList.add(cont.Boletines__r[0]);
        }

        List<Asistencia_a_Espacio_Educativo__c> asistenciaEspacioList = [SELECT Id, Boletin__r.Alumno__c, Mes__c, Espacio_Educativo__c, Asistencia1__c FROM Asistencia_a_Espacio_Educativo__c WHERE Boletin__c IN: boletinesIds ORDER BY Mes__c];
        List<ContentVersion> listaImagenes = [SELECT Id, FirstPublishLocationId FROM ContentVersion WHERE FirstPublishLocationId IN: becariosId];
        List<Inasistencia__c> faltasList = BoletinDataService.getListInasistencias(boletinesIds);
        List<Calificacion__c> calificacionesList = BoletinDataService.getListCalificaciones(boletinesIds);

        for(Asistencia_a_Espacio_Educativo__c a: asistenciaEspacioList){
            Id alumnoId = a.Boletin__r.Alumno__c;
            if(!inasistenciaAEspaciosByAlumno.containsKey(alumnoId)){
                inasistenciaAEspaciosByAlumno.put(alumnoId, new List<List<String>>{new List<String>{a.Mes__c, a.Espacio_Educativo__c, a.Asistencia1__c}});
            } else if(inasistenciaAEspaciosByAlumno.containsKey(alumnoId)){
                inasistenciaAEspaciosByAlumno.get(alumnoId).add(new List<String>{a.Mes__c, a.Espacio_Educativo__c, a.Asistencia1__c});
            }
        }
        
        for(ContentVersion imagenAlumno : listaImagenes){
            IdImagenAlumnoByIdAlumno.put(imagenAlumno.FirstPublishLocationId, imagenAlumno.Id);
        }

        //Vinculado al comentario de la linea 59
        for(Seguimiento_Educativo__c seg: seguimientosList)
            seguimientoMap.put(seg.Alumno__c, seg);
        
        for(Boletin__c bol :boletinesList){
            boletinMap.put(bol.Alumno__c, bol);

            if(!capacidadesByAlumno.containsKey(bol.Alumno__c)){
                capacidadesByAlumno.put(bol.Alumno__c, new List<List<String>>{
                    new List<String>{'Aprender a aprender',  bol.AAAPE__c, bol.AAAPEForm__c, bol.AAASE__c, bol.AAASEForm__c},
                    new List<String>{'Comunicación', bol.CPE__c, bol.CPEForm__c, bol.CSE__c, bol.CSEForm__c},
                    new List<String>{'Análisis y comprensión de la información', bol.AyCPE__c, bol.AyCPEForm__c, bol.AyCSE__c, bol.AyCSEForm__c},
                    new List<String>{'Pensamiento crítico', bol.PCPE__c, bol.PCPEForm__c, bol.PCSE__c, bol.PCSEForm__c},
                    new List<String>{'Organización y planificación', bol.OyPPE__c, bol.OyPPEForm__c, bol.OYPSE__c, bol.OYPSEForm__c},
                    new List<String>{'Trabajo con otros', bol.TcOPE__c, bol.TcOPEForm__c, bol.TcOSE__c, bol.TcOSEForm__c},
                    new List<String>{'Ciudadanía responsable', bol.CAPE__c, bol.CAPEForm__c, bol.CASE__c, bol.CASEForm__c}
                });
            }
        }

        for(Inasistencia__c fal :faltasList)
            if(faltasMap.containsKey(fal.Boletin__r.Alumno__c))
                faltasMap.get(fal.Boletin__r.Alumno__c).add(fal);                    
            else
                faltasMap.put(fal.Boletin__r.Alumno__c,new List<Inasistencia__c>{fal});
            
        for(Calificacion__c cal :calificacionesList)
            if(calificacionesMap.containsKey(cal.Boletin__r.Alumno__c))
                calificacionesMap.get(cal.Boletin__r.Alumno__c).add(cal);                    
            else
                calificacionesMap.put(cal.Boletin__r.Alumno__c,new List<Calificacion__c>{cal});
        
        for(Contact con :becariosList){   
            if(con.Pertenencias_a_Programas__r.size() > 0 && con.Pertenencias_a_Programas__r[0].Estado__c == 'Activo'){
                    contactWrapper res = new contactWrapper(boletinMap.get(con.Id), calificacionesMap.get(con.Id), faltasMap.get(con.Id), seguimientoMap.get(con.Id), pertenenciasMap.get(con.Id), IdImagenAlumnoByIdAlumno.get(con.Id), alumnoById.get(con.Id), capacidadesByAlumno.get(con.Id), actividadesProgramaMap.get(con.Id), inasistenciaAEspaciosByAlumno.get(con.Id));
                    resultList.add(res);
                    this.boleano = false;
                    System.debug(inasistenciaAEspaciosByAlumno.get(con.Id));            
            } else{
                this.boleano = true;
            }
        } 
    }
    
    
    public class contactWrapper{
        public Boletin__c boletin {get;set;}
        public List<Calificacion__c> listaDeCalificaciones {get; set;}
        public List<Inasistencia__c> listaDeInasistencias {get; set;}
        public Seguimiento_Educativo__c seguimiento {get;set;}
        public Pertenencia_a_Programas__c programa {get;set;}
        public Id ImagenDeAlumno {get;set;}
        public Contact thecontact {get;set;}
        public List<List<String>> capacidades {get;set;}
        public String actividadesPrograma {get;set;}
        public List<List<String>> asistenciaAEspacios {get;set;}

        public contactWrapper(Boletin__c boletinParaSetear, List<Calificacion__c> calificaciones, List<Inasistencia__c> faltas, Seguimiento_Educativo__c seguimiento, Pertenencia_a_Programas__c pertenencia, Id imagenDeAlumno, Contact thecontact, List<List<String>> capacidades, String actividadesPrograma, List<List<String>> asistenciaAEspacios){
           this.boletin = boletinParaSetear;
           this.listaDeCalificaciones = calificaciones;
           this.listaDeInasistencias = faltas;
           this.seguimiento = seguimiento;
           this.programa = pertenencia;
           this.ImagenDeAlumno = imagenDeAlumno;
           this.thecontact = thecontact;
           this.capacidades = capacidades;
           this.actividadesPrograma = actividadesPrograma;
           this.asistenciaAEspacios = asistenciaAEspacios;
        }
    }
}
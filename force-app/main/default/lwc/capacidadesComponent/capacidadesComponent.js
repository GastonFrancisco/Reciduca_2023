import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import  getCapacidades from '@salesforce/apex/BoletinDataService.getCapacidades';
import  updateCapacidades from '@salesforce/apex/BoletinDataService.updateCapacidades';
import { refreshApex } from '@salesforce/apex';

export default class CapacidadesComponent extends LightningElement {
    @api recordId;
    @track capacidades;
    error;
    primeraEvaluacion = [];
    segundaEvaluacion = [];
    fieldsToUpdate = {};
    modifiedFields = [];
    wiredCapacidades;
    primeraEvaluacionCompleta = false;

    booleanVar = true;
    // style = "background-color: rgb(250, 255, 189);"

    get options() {
       return [
            { label: 'No evaluado', value: 'No evaluado' },
            { label: 'Excelente', value: 'Excelente' },
            { label: 'Muy bueno', value: 'Muy bueno' },
            { label: 'Bueno', value: 'Bueno' },
            { label: 'Regular', value: 'Regular' },
            { label: 'Mejorable', value: 'Mejorable' }
        ];
    }
        
    @wire(getCapacidades, { recordId: '$recordId' })
    wiredRecord( result ){
        this.wiredCapacidades = result;
        if(result.data){
            this.capacidades = result.data;
            this.error = undefined;
            this.primeraEvaluacion = [
                {name: 'Aprender a aprender', picklist: this.capacidades.AAAPE__c, form: this.capacidades.AAAPEForm__c, fieldName: 'AAAPE__c'},
                {name: 'Comunicación', picklist: this.capacidades.CPE__c, form: this.capacidades.CPEForm__c, fieldName: 'CPE__c'},
                {name: 'Análisis y comprensión de la información', picklist: this.capacidades.AyCPE__c, form: this.capacidades.AyCPEForm__c, fieldName: 'AyCPE__c'},
                {name: 'Pensamiento crítico', picklist: this.capacidades.PCPE__c, form: this.capacidades.PCPEForm__c, fieldName: 'PCPE__c'},
                {name: 'Organización y planificación', picklist: this.capacidades.OyPPE__c, form: this.capacidades.OyPPEForm__c, fieldName: 'OyPPE__c'},
                {name: 'Trabajo con otros', picklist: this.capacidades.TcOPE__c, form: this.capacidades.TcOPEForm__c, fieldName: 'TcOPE__c'},
                {name: 'Ciudadanía responsable', picklist: this.capacidades.CAPE__c, form: this.capacidades.CAPEForm__c, fieldName: 'CAPE__c'}
            ];
            this.segundaEvaluacion = [
                {name: 'Aprender a aprender', picklist: this.capacidades.AAASE__c, form: this.capacidades.AAASEForm__c, fieldName: 'AAASE__c'},
                {name: 'Comunicación', picklist: this.capacidades.CSE__c, form: this.capacidades.CSEForm__c, fieldName: 'CSE__c'},
                {name: 'Análisis y comprensión de la información', picklist: this.capacidades.AyCSE__c, form: this.capacidades.AyCSEForm__c, fieldName: 'AyCSE__c'},
                {name: 'Pensamiento crítico', picklist: this.capacidades.PCSE__c, form: this.capacidades.PCSEForm__c, fieldName: 'PCSE__c'},
                {name: 'Organización y planificación', picklist: this.capacidades.OYPSE__c, form: this.capacidades.OyPSEForm__c, fieldName: 'OYPSE__c'},
                {name: 'Trabajo con otros', picklist: this.capacidades.TcOSE__c, form: this.capacidades.TcOSEForm__c, fieldName: 'TcOSE__c'},
                {name: 'Ciudadanía responsable', picklist: this.capacidades.CASE__c, form: this.capacidades.CASEForm__c, fieldName: 'CASE__c'}
            ];
            this.primeraEvaluacionCompleta = this.capacidades.Eval1_completa__c;
            this.fieldsToUpdate.Id = this.recordId;
        } else if (result.error){
            this.error = result.error;
            console.log(this.error);
        }
    }

    handleChange(event) {
        this.fieldsToUpdate[`${event.target.label}`] = event.detail.value;
        console.log(this.fieldsToUpdate)
        this.disabled();
/*         this.style = "background-color: rgb(250, 255, 189);"
        this.template.querySelector(`tr[key=${event.target.label}]`).style = `${this.style}`; */
    }

    handleSubmit(){
        console.log(JSON.stringify(this.fieldsToUpdate));
        updateCapacidades({ data: JSON.stringify(this.fieldsToUpdate) })
        .then(() => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Capacidad actualizada',
                variant: 'success'
            }))
            this.refresh(this.wiredCapacidades);
            this.handleReset();
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: error,
                variant: 'error'
            }))
            this.handleReset();
        })
    }

    /* Por cada cambio en los valores del combobox que estan en "this.fieldsToUpdate" se genera un array de keys(campos) 
    llamado "this.modifiedFields". Estas keys se utilizan para buscar los elementos combobox por medio de su "data-id" en el html, y 
    luego los valores que llegaron de la base de datos. Esto se logra utilizando el metodo find con la key como parametro sobre 
    los arrays "this.primeraEvaluacion" y "this.segundaEvaluacion"*/
    handleReset(){
        this.modifiedFields = Object.keys(this.fieldsToUpdate).filter(key => key != 'Id')
        this.modifiedFields.forEach(field => {
            this.template.querySelector(`lightning-combobox[data-id=${field}]`).value = this.capacidades[`${field}`];
        });
        this.fieldsToUpdate = {Id: this.recordId};
        this.disabled();
    }

    @api async refresh(arrayToUpdate) {
        await refreshApex(arrayToUpdate);
    }

    //Este metodo se puede utilizar para desabilitar el boton de save
    disabled(){ 
        if (Object.values(this.fieldsToUpdate).length > 1) {
            this.booleanVar = false;
        } 
        else {
            this.booleanVar = true;
        } 
    }
}
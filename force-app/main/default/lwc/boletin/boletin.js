import { LightningElement, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getCalificaciones from '@salesforce/apex/BoletinDataService.getCalificaciones';
import getInasistencias from '@salesforce/apex/BoletinDataService.getInasistencias';
import updateCalificacion from '@salesforce/apex/BoletinDataService.updateCalificacion';
import updateInasistencia from '@salesforce/apex/BoletinDataService.updateInasistencia';
import CUATRIMESTRAL from '@salesforce/schema/Boletin__c.Cuatrimestral__c';
const actions = [
    { label: 'Aprobar', name: 'aprobar' },
];
export default class Boletin extends LightningElement {

    calificaciones = [];
    inasistencias = [];
    wiredCalificacionesResult = [];
    wiredInasistenciasResult = [];
    @api recordId;  //Id del boletín presente
    boolean = false;
    columnsCalificacion = [];
    columnsInasistencia = [];

    @wire(getRecord, { recordId: '$recordId', fields: CUATRIMESTRAL})
    boletin({ error, data }){
        if(data){
            let gradesColumn = [
                { label: 'Materia', fieldName: 'MateriaName', editable: false },
                { label: 'Primera evaluación', fieldName: 'Primer_trimestre__c', editable: true, type: 'number' },
                { label: 'Segunda evaluación', fieldName: 'Segundo_trimestre__c', editable: true, type: 'number' },
                { label: 'Tercera evaluación', fieldName: 'Tercer_trimestre__c', editable: true, type: 'number' },
                { label: 'Final', fieldName: 'Final__c', editable: true, type: 'number' },
                { label: 'Estado', fieldName: 'Estado__c', type: 'text'},
                {
                    type: 'action',
                    typeAttributes: { rowActions: actions },
                }
            ];
            let absenceColumn = [
                { label: 'Primera evaluación', fieldName: 'Primer_trimestre__c', editable: true, type: 'number' },
                { label: 'Segunda evaluación', fieldName: 'Segundo_trimestre__c', editable: true, type: 'number' },
                { label: 'Tercera evaluación', fieldName: 'Tercer_trimestre__c', editable: true, type: 'number' },
            ];
            this.boolean = data.fields.Cuatrimestral__c.value;
            if(this.boolean){
                gradesColumn.splice(3,1);
                absenceColumn.splice(2,1);
            }
            this.columnsCalificacion = gradesColumn;
            this.columnsInasistencia = absenceColumn;
        } else if (error){
            console.log(error);
        }
    }

    get cuatrimestral() {
        return getFieldValue(this.boletin.data, CUATRIMESTRAL);
    }


    //trae las calificaciones con lookup al boletín
    //crea el campo JS MateriaName a partir del campo Apex Materia__r.Name
    @wire(getCalificaciones, { boletinId: '$recordId' })
    wiredCalificaciones(result) {
        this.wiredCalificacionesResult = result;
        if (result.data) {
            this.calificaciones = result.data.map(item => {
                return { ...item, MateriaName: item.Materia__r.Name }
            })
        }
    }

    //trae la inasistencia con lookup al boletín
    @wire(getInasistencias, { boletinId: '$recordId' })
    wiredInasistencias(result) {
        this.wiredInasistenciasResult = result;
        if (result.data) this.inasistencias = result.data;
    }

    saveCalificaciones(event) {
        const updatedFields = event.detail.draftValues;
        console.log(JSON.stringify(event.detail.draftValues));
        updateCalificacion({ data: updatedFields })
            .then(() => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Calificación actualizada',
                    variant: 'success'
                }))
                this.refresh(this.wiredCalificacionesResult);
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: 'Ingrese un valor correcto.',
                    variant: 'error'
                }))
            })
            .finally(() => {
                // event.detail.draftValues = [];
                this.template.querySelector("lightning-datatable").draftValues = []
                console.log("done");
            });
    }

    saveInasistencia(event) {
        const updatedFields = event.detail.draftValues;
        updateInasistencia({ data: updatedFields })
            .then(() => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Inasistencia actualizada',
                    variant: 'success'
                }))
                this.refresh(this.wiredInasistenciasResult);
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: 'Ingrese un valor correcto.',
                    variant: 'error'
                }))
            })
            .finally(() => {
                this.template.querySelector("lightning-datatable").draftValues = []
            });
    }

    handleRowApprove(event){
        event.detail.row.Estado__c = "Aprobado";
        delete event.detail.row.Materia__r;
        console.log(JSON.stringify([event.detail.row]));
        updateCalificacion({ data: [event.detail.row] })
            .then(() => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Calificación actualizada',
                    variant: 'success'
                }))
                this.refresh(this.wiredCalificacionesResult);
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: 'Ingrese un valor correcto.',
                    variant: 'error'
                }))
            })
            .finally(() => {
                // event.detail.draftValues = [];
                this.template.querySelector("lightning-datatable").draftValues = []
                console.log("done");
            });

    }

    //refresca las calificaciones asincrónicamente
    @api async refresh(arrayToUpdate) {
        await refreshApex(arrayToUpdate);
    }
}

//console.log(event.target.dataset.recordId)
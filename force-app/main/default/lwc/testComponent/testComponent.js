import { LightningElement } from 'lwc';

export default class TestComponent extends LightningElement {
    connectedCallback() {
        console.log('TestComponent connected');
    }
}
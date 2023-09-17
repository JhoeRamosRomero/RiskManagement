using { riskmanagements as rm } from '../db/schema';

//@path : 'service/risk'
service  RiskService @(path: 'service/risk'){

    //DELETE -> entity Risks as projection on rm.Risks;
    
    entity Risks @(restrict: [
        {
            grant: [ 'READ' ],
            to: [ 'RiskViewer' ]
        },
        {
            grant: [ '*' ],
            to: [ 'RiskManager' ]
        }
    ]) as projection on rm.Risks;
    annotate Risks with @odata.draft.enabled;

    //DELETE -> entity Mitigations as projection on rm.Mitigations;
    entity Mitigations @(restrict: [
        {
            grant: [ 'READ' ],
            to: [ 'RiskViewer' ]
        },
        {
            grant: [ '*' ],
            to: [ 'RiskManager' ]            
        }
    ] ) as projection on rm.Mitigations
    annotate Mitigations with @odata.draft.enable;

    @readonly entity BusinessPartners as projection on rm.BusinessPartners;  

}
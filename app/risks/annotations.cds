using RiskService as service from '../../srv/risk-service';

//--- List report page
annotate service.Risks with @(UI : {

    HeaderInfo: {

        TypeNamePlural: 'Risks',
        TypeName: 'Risk',
        Title: {
            $Type: 'UI.DataField',
            Value: title
        },
        Description: {

            $Type: 'UI.DataField',
            Value: descr

        }

    },
    SelectionFields : [

        prio

    ],
    Identification: [

        { Value: title }

    ],
    LineItem: [

        { Value: title },
        { Value: miti_ID },
        { Value: owner },
        { Value: bp_BusinessPartner },
        { Value: prio, Criticality: criticality },
        { Value: impact, Criticality: criticality },

    ]

});

//--- Risk Object Page
annotate service.Risks with @(UI : {

    Facets: [
        {

            $Type: 'UI.ReferenceFacet',
            Label: 'Main',
            Target: '@UI.FieldGroup#Main'

        }
    ],
    FieldGroup #Main: { Data: [

        { Value: miti_ID },
        { Value: owner },
        { Value: prio, Criticality: criticality },
        { Value: impact, Criticality: criticality },
        { Value: bp_BusinessPartner }

    ] }

});
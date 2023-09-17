using riskmanagements as rm from '../db/schema';

//--- Annotate Risk elements
annotate rm.Risks with {

    ID     @title: 'Risk';
    title  @title: 'Title';
    owner  @title: 'Owner';
    bp     @title: 'Business Partner';
    prio   @title: 'Priority';
    descr  @title: 'Description';
    miti   @title: 'Mitigation';
    impact @title: 'Impact';

}


//--- Annonate Mitigation Elements
annotate rm.Mitigations with {

    ID    @(
        UI.Hidden,
        Common: {Text: descr}
    );
    owner @title: 'Owner';
    descr @title: 'Description';

}

annotate rm.BusinessPartners with {

    BusinessPartner @(
        UI.Hidden,
        Common: { Text: LastName }
    );
    FirstName @title: 'First Name';
    LastName @title: 'Last Name';

}

annotate rm.Risks with {

    miti @(Common: {

        Text           : miti.descr,
        TextArrangement: #TextOnly,
        ValueList      : {

            Label         : 'Mitigations',
            CollectionPath: 'Mitigations',
            Parameters    : [

                {

                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: miti_ID,
                    ValueListProperty: 'ID'

                },
                {

                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'descr'

                }

            ]

        }

    });

    bp @(Common: {

        Text: bp.LastName,
        TextArrangement: #TextOnly,

        ValueList: {

            Label: 'Business Partners',
            CollectionPath: 'BusinessPartners',
            Parameters: [

                {

                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: bp_BusinessPartner,
                    ValueListProperty: 'c'

                },
                {

                    $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'FirstName',

                },
                {

                    $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'LastName'

                }

            ]

        }

    } );

}
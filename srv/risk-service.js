//--- Imports
const cds = require( "@sap/cds" );

/**
* La implementación del servicio con todos los manejadores de servicios.
*/

module.exports = cds.service.impl( async function() {

    // Definir constantes para las entidades Risk y BusinessPartners desde el archivo Risk-service.cds
    const { Risks, BusinessPartners } = this.entities;

    //--- Establecemos la criticidad de los riesgos
    estableceCriticidad( this, Risks );

    // connect to remote service
    const connectionBusinessParner = await cds.connect.to( "API_BUSINESS_PARTNER" );

    callBusinessParnerService( this, BusinessPartners, connectionBusinessParner )

    expandBusinessPartner( this, Risks, connectionBusinessParner )

} );


function estableceCriticidad( context, Risks ){

    /**
    * Establecer criticidad después de una operación de LECTURA en /riesgos
    */

    context.after( "READ", Risks, ( data ) => {
        
        const risks = Array.isArray( data ) ? data : [data];

        risks.forEach( ( risk ) => {

            if( risk.impact >= 100000 ){
                risk.criticality = 1;
            }else{
                risk.criticality = 2;
            }

        } );

    } );

}

function callBusinessParnerService( context, BusinessPartners, connectionBusinessParner ){


    console.log( "CONSULTANDO INFORMACIÓN DE LOS BUSINESS PARTNERS" )
    console.log( "BusinessPartners: ", BusinessPartners )

    context.on( "READ", BusinessPartners, async (req, res) => {

        console.log( "OPTIONAS: ", req.query )

        // Configura la opción $count en false
        req.query.SELECT.count = false;

        req.query.where( "LastName <> '' and FirstName <> '' " );

        return connectionBusinessParner.transaction( req ).send( {

            query: req.query,
            headers: {

                apikey: process.env.apikey

            }

        } );

    } );

}

function expandBusinessPartner (  context, Risks, connectionBusinessParner ) {

    context.on( "READ", Risks, async ( req, next ) => {

        if( !req.query.SELECT.columns ) return next();

        const expandItem = req.query.SELECT.columns.findIndex( ( { ref, expand } ) => {

            return ref[0] === 'bp' && expand !== undefined

        } );

        if( expandItem < 0 ) return next();

        req.query.SELECT.columns.splice( expandItem, 1 );

        let columnBusinessPartner = req.query.SELECT.columns.find( ( column ) => {

            return column.ref.find( ( ref ) => ref == "bp_BusinessPartner" )

        } )

        if( !columnBusinessPartner ) {

            req.query.SELECT.columns.push( { ref: ["bp_BusinessPartner"]  } );

        }

        try{

            var res = await next()

            res = Array.isArray( res ) ? res : [ res ]

            await Promise.all( res.map( async ( risk ) => {

                const bp = await connectionBusinessParner.transaction( req ).send( {

                    query: SELECT.one( context.entities.BusinessPartners )
                    .where( { BusinessPartner: risk.bp_BusinessPartner } )
                    .columns( [ "BusinessPartner", "LastName", "FirstName" ] ),
                    headers: {

                        apikey: process.env.apikey

                    }

                } ) ;

                risk.bp = bp;

            } ) ).catch( ( error ) => {

                console.log( "Ocurrió un problema al consultar la inforamción del API Bussiness Partner: ", error )

            } )

        }catch( ex ){} 

    } );    

}
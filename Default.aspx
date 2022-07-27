<script runat="server">

    Protected Sub Page_Load(sender As Object, e As EventArgs)

    End Sub
</script>

     


<html lang="tr">
<head>
    <meta charset="utf-8">
    <title>Map</title>

    <link rel="stylesheet" href="https://openlayers.org/en/v3.20.1/css/ol.css" type="text/css">
    <script src="https://cdn.jsdelivr.net/gh/openlayers/openlayers.github.io@master/en/v6.5.0/build/ol.js"></script>

            

   
    <link href="https://cdn.jsdelivr.net/npm/jspanel4@4.11.1/dist/jspanel.css" rel="stylesheet">
 
    <script src="https://cdn.jsdelivr.net/npm/jspanel4@4.11.1/dist/jspanel.js"></script>

   
    <script src="https://cdn.jsdelivr.net/npm/jspanel4@4.11.1/dist/extensions/modal/jspanel.modal.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspanel4@4.11.1/dist/extensions/tooltip/jspanel.tooltip.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspanel4@4.11.1/dist/extensions/hint/jspanel.hint.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspanel4@4.11.1/dist/extensions/layout/jspanel.layout.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspanel4@4.11.1/dist/extensions/contextmenu/jspanel.contextmenu.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspanel4@4.11.1/dist/extensions/dock/jspanel.dock.js"></script>

    

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    


    <style>
        .map {
            width: 120%;
            height: 500px;
        }

        .ol-popup {
            color: blue;
        }
        #type {
            margin-left: 2px;
            height: 18px;
            width: 114px;
        }
    </style>

</head>

<body>



    <form id="form1" runat="server">



    <div id="map" class="map"></div>
    <div id="popup" class="ol-popup">
        <a href="#" id="popup-closer" class="ol-popup-closer"></a>
        <div id="popup-content"></div>
    </div>

        <br>

    <textBox>Geometry Type:</textBox><select id="type" name="D1">
            <option>Ekle</option>
            <option value="Point">Point</option>
            <option value="Polygon">Polygon</option>
            <option value="LineString">LineString</option>


        </select>

        <button>Edit</button>
    
    &nbsp;<div>
              <br>      
        
    <asp:GridView ID="GridView1" runat="server"
    AutoGenerateColumns="False"
    DataSourceID="SqlDataSource1" 
    CellPadding="4" GridLines="None" Width="868px" ForeColor="#333333">
  
   <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
  
    
 <Columns>
       
      <asp:TemplateField HeaderText ="İl">
            
           <ItemTemplate>
                <asp:Label Text ='<%#Eval("il")%>' runat="server" />
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="txtİl"  Text='<%# Eval("il") %>' runat="server"  />  
            </EditItemTemplate>
            <FooterTemplate>
                <asp:TextBox ID="txtİlfooter" runat="server"  />
            </FooterTemplate>

          </asp:TemplateField>
        

     <asp:TemplateField HeaderText ="İlçe">
            
           <ItemTemplate>
                <asp:Label Text ='<%#Eval("ilce")%>' runat="server" />
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="txtİlçe"  Text='<%# Eval("ilce") %>' runat="server"  />  
            </EditItemTemplate>
            <FooterTemplate>
                <asp:TextBox ID="txtİlçefooter" runat="server"  />
            </FooterTemplate>

          </asp:TemplateField>

     <asp:TemplateField HeaderText ="Mahalle">
            
           <ItemTemplate>
                <asp:Label Text ='<%#Eval("mahalle")%>' runat="server" />
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="txtM"  Text='<%# Eval("mahalle") %>' runat="server"  />  
            </EditItemTemplate>
            <FooterTemplate>
                <asp:TextBox ID="txtMfooter" runat="server"  />
            </FooterTemplate>

          </asp:TemplateField>
      
        <asp:TemplateField>
            <ItemTemplate>



                <asp:Button text="Edit"  runat="server"  CommandName="Edit" ToolTip="Güncelle"  Width="45px"  Height="25px"/>
                <asp:Button text="Delete" runat="server" CommandName="Delete" ToolTip="Sil" Width="45px" Height ="25px"/>
            </ItemTemplate>
            </asp:TemplateField>

    </Columns>
            
               <EditRowStyle BackColor="#999999" />
               <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
               <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
               <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
               <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
               <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
               <SortedAscendingCellStyle BackColor="#E9E7E2" />
               <SortedAscendingHeaderStyle BackColor="#506C8C" />
               <SortedDescendingCellStyle BackColor="#FFFDF8" />
               <SortedDescendingHeaderStyle BackColor="#6F8DAE" />

              
</asp:GridView>



               <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:mapConnectionString2 %>" SelectCommand="SELECT * FROM [map]"></asp:SqlDataSource>




</div>

    <script>
        var AerialWithLabels = new ol.layer.Tile({
            source: new ol.source.OSM()
        });



        var middle = ol.proj.fromLonLat([35.2433, 38.9637]);


        var view = new ol.View({
            center: middle,
            zoom: 6
        });


        var map = new ol.Map({
            target: 'map',
            layers: [AerialWithLabels],
            view: view




        });

        var features = new ol.Collection();

        var source = new ol.source.Vector({ features: features });

        var vectorLayerM = new ol.layer.Vector({
            source: source,

            style: new ol.style.Style({
                fill: new ol.style.Fill({
                    color: 'rgba(255, 255, 255, 0.2)'
                }),
                stroke: new ol.style.Stroke({
                    color: '#ffcc33',
                    width: 2
                })

            })
        });

        map.addLayer(vectorLayerM);

        var vectorLayerK = new ol.layer.Vector({
            source: source,
            style: new ol.style.Style({

                image: new ol.style.Circle({
                    radius: 5,
                    fill: new ol.style.Fill({
                        color: '#ffcc33'
                    })
                })

            })

        });

        map.addLayer(vectorLayerK);


        var modify = new ol.interaction.Modify({
            features: features,

            deleteCondition: function (event) {
                return ol.events.condition.shiftKeyOnly(event) &&
                    ol.events.condition.singleClick(event);
            }
        });
        map.addInteraction(modify);


        var draw;
        var draw1;
        var draw2;
        var typeSelect = document.getElementById('type');


        function addInteractionP() {
            draw = new ol.interaction.Draw({
                features: features,
                type: 'Point'
            });
            map.addInteraction(draw);

        }

        function addInteractionPoly() {
            draw1 = new ol.interaction.Draw({
                features: features,
                type: 'Polygon'
            });
            map.addInteraction(draw1);

        }

        function addInteractionLine() {
            draw2 = new ol.interaction.Draw({
                features: features,
                type: 'LineString'
            });
            map.addInteraction(draw2);
        }


        var modify1 = new ol.interaction.Modify({
            source: source
        });
        map.addInteraction(modify1);


        var snap;

        function addInteractions() {
            addInteractionPoly();
            addInteractionP();
            addInteractionLine();

            snap = new ol.interaction.Snap({
                source: source
            });

            map.addInteraction(snap);
        }

        var data;
        var coords;



        typeSelect.onchange = function () {
         
            if (typeSelect.value === 'Point') {
                map.removeInteraction(draw);
                map.removeInteraction(draw1);
                map.removeInteraction(draw2);

                addInteractionP();

                draw.on('drawend', function (e) {
                   
                    var currentFeature = e.feature;

                    coords = currentFeature.getGeometry().getCoordinates();
                    draw.setActive(false);

                    jsPanel.create({
                        id: "point-panel",

                        headerTitle: 'Point Ekle',
                        position: 'center-top 0 58',
                        contentSize: '300 250',
                        content: 'İl: <br><input id="il" type="text"/><br> <br> İlçe: <br ><input id="ilce" type="text"/> <br><br> Mahalle: <br ><input id="mahalle" type="text"/>     <br><br><br><button style="height:50px;width:60px" id="kapi_kaydet" class="btn btn-success">Kaydet</button>',
                        callback: function () {
                            this.content.style.padding = '20px';
                        }
                    });

                });


            } else if (typeSelect.value === 'Polygon') {
               

                map.removeInteraction(draw1);
                map.removeInteraction(draw);
                map.removeInteraction(draw2);

                addInteractionPoly();

                
                draw1.on('drawend', function (e) {

                   
                    var currentFeature = e.feature;

                    coords = currentFeature.getGeometry().getCoordinates()[0];
                    draw1.setActive(false);

                    jsPanel.create({
                        id: "polygon-panel",

                        headerTitle: 'Polygon Ekle',
                        position: 'center-top 0 58',
                        contentSize: '300 250',
                        content: 'İl: <br><input id="il" type="text"/><br> <br> İlçe: <br ><input id="ilce" type="text"/> <br><br> Mahalle: <br ><input id="mahalle" type="text"/>     <br><br><br><button style="height:50px;width:60px" id="kapi_kaydet" class="btn btn-success">Kaydet</button>',
                        callback: function () {
                            this.content.style.padding = '20px';
                        }
                    });

                });


            } else if (typeSelect.value === 'LineString') {
                map.removeInteraction(draw);
                map.removeInteraction(draw1);
                map.removeInteraction(draw2);
                map.removeInteraction(snap);

                addInteractionLine();

                draw2.on('drawend', function (e) {


                    var currentFeature = e.feature;

                    coords = currentFeature.getGeometry().getCoordinates()[0];
                    draw2.setActive(false);

                    jsPanel.create({
                        id: "line-panel",

                        headerTitle: 'Line String Ekle',
                        position: 'center-top 0 58',
                        contentSize: '300 250',
                        content: 'İl: <br><input id="il" type="text"/><br> <br> İlçe: <br ><input id="ilce" type="text"/> <br><br> Mahalle: <br ><input id="mahalle" type="text"/>     <br><br><br><button style="height:50px;width:60px" id="kapi_kaydet" class="btn btn-success">Kaydet</button>',
                        callback: function () {
                            this.content.style.padding = '20px';
                        }
                    });

                });
          
            }
        };


       

      
      


    </script>
 
    </form>


  

</body>

</html>
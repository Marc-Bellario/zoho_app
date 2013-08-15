package WxAddChg; use base qw(Wx::App Exporter); 
# use Class::Date qw(:errors date localdate gmdate now -DateParse -EnvC);
use strict; 
use Exporter; 
our $VERSION = 0.10;
our @EXPORT_OK = qw(StartApp FindWindowByXid MsgBox $frame $xr show_add show_dialog %test_list 
$xrc $frmID $sbar %menu $CloseWin $icon %txtctrl $dialog $frameGrid ) ; 
use Wx qw(wxDefaultPosition wxDefaultSize wxDP_ALLOWNONE); 
# use Wx::Grid;
use Carp; 
our $dialog; 
our $xr; 
#our $xrc = 'res/res.xrc'; # location of resource file 
our $xrc = './res/xrc_edit_add_dialog.xrc'; # location of resource file 
use WxStats qw($frame show_stats $currentData $CloseWin);
use WxDelete qw($frame show_delete  $currentData);     

our $dialogID = 'MyDialogE'; # XML ID of the main frame 


our $CloseWin = \&CloseWin; # this is not a menu option 
# it is the routine called before the end 
# it needs to Destroy() all top level dialogs 
our $icon = Wx::GetWxPerlIcon(); 
my $file; # the name of the file used in Open/Save
my %cntlHash = ();
my $g_type;
my $g_delete;

   my @lclDBData;

    my $bname;
    my $lastname;
    my $firstname;
    my $address;
    my $state;
    my $city;
    my $zip;
    my $phone;
    my $date;
    my $ptype;
    my $note;
    my $email;
    my $refto;
    my $refby;
    my $mtype;
    my $refdate;
    my $orgdate;
    my $stat;
    my $mphone;

# our $currentData;
    	 my @dbColumns =          qw(  
                    Lead_BusinessName 
                    Lead_FirstName 
                    Lead_LastName 
                    Lead_BusinessPhone 
                    Lead_MobilePhone 
                    Lead_Email 
                    Lead_Dealer_ReferedTo 
                    Lead_ReferalDate 
                    Lead_Street  
                    Lead_City  
                    Lead_State  
                    Lead_Zip  
                    Lead_Equipment_Type  
                    Lead_Model   
                    Lead_Notes  
                    Lead_Origin
                    Refered_By_Data 
                    Finance_Required 
                    Sales_Status 
                    Sales_Quote 
                    Sales_Quote_Other 
                     Lead_Sales_Create_Date
                     Lead_Error_Type);


sub OnInit 
{ my $app = shift; 
# 
# Load XML Resources 
# 
use Wx::XRC; 
$xr = Wx::XmlResource->new(); 
$xr->InitAllHandlers(); 
croak "No Resource file $xrc" unless -e $xrc; 
$xr->Load( $xrc ); 
# 
# Load the main frame from resources 
# 
# $dialog = 'Wx::Dialog'->new(our $frame); 
croak "No dialog named $dialogID in $xrc" unless 
$dialog = $xr->LoadDialog(our $frame, $dialogID);

# debug - print " pm - dialog = $dialog \n";
          WxStats->new();
          WxDelete->new();
          
    $bname = FindWindowByXid('tbBName');
    $lastname = FindWindowByXid('tbLName');
    $firstname = FindWindowByXid('tbFName');
    $address = FindWindowByXid('tbAddress');
    $state = FindWindowByXid('cbState');
    $city = FindWindowByXid('tbCity');
    $zip =   FindWindowByXid('tbZip');
    $phone = FindWindowByXid('tbPhone');
    $date = FindWindowByXid('m_datePicker2');
    $ptype = FindWindowByXid('cbProdType');
    $email = FindWindowByXid('tbEmail');
    $refto = FindWindowByXid('cbRefTo');
    $refby = FindWindowByXid('cbRefBy');
    $mtype = FindWindowByXid('cbModelType');
    $refdate = FindWindowByXid('m_datePicker21');
    $orgdate = FindWindowByXid ('m_datePicker2');
    $stat = FindWindowByXid ('cbStat');
    $mphone = FindWindowByXid ('tbMobile');
    $note = FindWindowByXid('m_textCtrl10');

  %cntlHash = qw( 
   bname     $bname
   lastname  $lastname
   firstname $firstname
   address   $address
   state     $state
   city      $city
   phone     $phone
   date      $date
   type      $type
   note      $note
   zip        $zip
 );

# debug - print " pm - frame = $frame \n";

my ( $idAdd) = FindWindowByXid('btnAdd');
Wx::Event::EVT_BUTTON($dialog, $idAdd, \&OnUpdate );

my ($idCancel) = FindWindowByXid('btnCancel');
Wx::Event::EVT_BUTTON($dialog, $idCancel, sub { $_[0]->Close } );

my ($idExport) = FindWindowByXid('btnExport');
Wx::Event::EVT_BUTTON($dialog, $idExport, \&OnExport );

my ($idLink0) = FindWindowByXid('m_hyperlink0');
 Wx::Event::EVT_HYPERLINK($dialog,$idLink0, \&GetStat);

#my ($idLink) = FindWindowByXid('m_hyperlink1');
# Wx::Event::EVT_HYPERLINK($dialog,$idLink, \&GetNote);

my $ck_dialog = 0;
if ( $ck_dialog)
{
 our $dialogGrid = $xr->LoadDialog( $frame,  'MyDialog1' );
}

#our $frameGrid = $xr->LoadObject(undef, 'm_grid3', 'Wx::Grid');

append_combos();
 
if (my $sbar) 
{  $frame->CreateStatusBar( $sbar ); 
   $frame->SetStatusWidths(-1,200); 
} 
# our $frame->SetIcon( $icon ); 
# 
# Set event handlers 
# 
use Wx::Event qw(EVT_MENU EVT_CLOSE); 
# 
# Show the window 
# 
1; 
} 
sub FindWindowByXid 
{ my $id = Wx::XmlResource::GetXRCID($_[0], -2);
return undef if $id == -2; 
my $win = Wx::Window::FindWindowById($id, our $frame); 
return wantarray ? ($win, $id) : $win; 
} 
sub MsgBox 
{ use Wx qw (wxOK wxICON_EXCLAMATION); 
my @args = @_; 
$args[1] = 'Message' unless defined $args[1]; 
$args[2] = wxOK | wxICON_EXCLAMATION unless defined $args[2]; 
my $md = Wx::MessageDialog->new(our $frame, @args); 
$md->ShowModal(); 
} 

sub append_combos
{
    use YAML qw(LoadFile);

    my @settingsA = LoadFile('.\res\stat.yaml');
    
    
    my  (@settings) = LoadFile('.\res\states.yaml');
    my  (@settings0) = LoadFile('.\res\etype.yaml');
    my  (@settings1) = LoadFile('.\res\model.yaml');
    my  (@settings2) = LoadFile('.\res\dealer.yaml'); 
 
    my    $state = FindWindowByXid('cbState');
    my    $etype = FindWindowByXid('cbProdType');
    my    $stat = FindWindowByXid('cbStat');
    my    $refTo = FindWindowByXid('cbRefTo');
    my    $refBy = FindWindowByXid('cbRefBy');
    my    $model =  FindWindowByXid('cbModelType');
 
      my $len = @settings; 
 
      print " append_combos - stat len: $len\n"; 
 
 
      foreach my $r (@settingsA)
      {
             $stat->Append($r);
      }
 
      foreach my $s (@settings)
      {
             $state->Append($s);
      }
      
      foreach my $t (@settings0)
      {
             $etype->Append($t);
      }    
    
      foreach my $a (@settings1)
      {
             $model->Append($a);
      }
      
      foreach my $b (@settings2)
      {
             $refBy->Append($b);
             $refTo->Append($b);
      }    

}                               

sub show_add {
    my( $self, $event, $parent ) = @_;

#    my $dialog = $self->xrc->LoadDialog( $parent || $self, 'dlg1' );
    $dialog->ShowModal();
#    $dialog->Destroy;
}       


sub show_dialog {
#    my( $self, $event, $parent ) = @_;
   my ($type, @thisCurrentData ) = @_;
   
   @lclDBData = @thisCurrentData;

             my $idClear = FindWindowByXid('btnClear');

             my $idA1 = FindWindowByXid('btnAdd');

    $g_type = $type;

   if ($type == 1) 
   { 
    print " ADD - $type \n "; 
    #      $idA1->SetLabel( "ADD");   
          $lclDBData[0] = "-99";
          $idA1->SetLabel( "Add" );
          $idClear->SetLabel( "Clear");
          Wx::Event::EVT_BUTTON($dialog, $idClear, \&Clear );  
          Clear();
    } 
    else 
    { 
    
        if ( $type == 0 )
        {
                print "CHG - $type\n"; 
    
          $idA1->SetLabel( "Change" );
          $idClear->SetLabel( "Delete" );
        }
        else
        {
            print " IMPORT - $type\n ";
            $idA1->SetLabel( "Add" );
            $idClear->SetLabel( "Delete" );
        }
        

Wx::Event::EVT_BUTTON($dialog, $idClear, \&Delete );   
   
   
   
   print " sub $dialog \n ";
   my $id;
   
    
#      my $sizer = $date->GetContainingSizer();
#      my $parentP = $date->GetParent();
      my $sizer;
      my $parentP;



#       $date->Hide();
#      $date->SetDefaultStyle( wxDP_ALLOWNONE);
#    $date->SetStyle( wxDP_ALLOWNONE );
#     $sizer->DeleteWindows();

my $dater;
if (0){
#    $sizer->DeleteWindows();
    $sizer->Replace($date, Wx::DatePickerCtrl->new(
    $parentP,
    -1,
    Wx::DateTime->newFromDMY(10,10,2010, 1,1,1,1),
    wxDefaultPosition,
    wxDefaultSize,
    wxDP_ALLOWNONE
));  

    
    
   } else { print "sizer - not found\n"; }
   
   # if ( our $currentIndex ) print " currentIndex = $currentIndex\n";
    my @data = ();
       @data = @lclDBData;
    
    $id = $data[0];
   my $currentLength = scalar @data;
#   print " current data : $thisCurrentData \n";
   print " current data len: $currentLength \n ";
   
   if ( $currentLength > 1 && $data[1] ne ".") {  $bname->ChangeValue($data[1]) } else { $bname->ChangeValue("")} ;
   if ( $currentLength > 2 && $data[2] ne ".") {  $firstname->ChangeValue($data[2]) } else { $firstname->ChangeValue("")} ;
   if ( $currentLength > 3 && $data[3] ne ".") { $lastname->ChangeValue($data[3]) } else {$lastname->ChangeValue("")} ;
   if ( $currentLength > 4  && $data[4] ne ".") { $phone->ChangeValue($data[4]) } else {$phone->ChangeValue("")}; 
   if ( $currentLength > 10  && $data[10] ne ".") { $city->ChangeValue($data[10]) } else {$city->ChangeValue("")}; 
   if ( $currentLength > 9 && $data[9] ne ".") {  $address->ChangeValue($data[9]) } else { $address->ChangeValue("")} ;
   if ( $currentLength > 11 && $data[11] ne ".") { $state->SetValue($data[11]) };
    if ( $currentLength > 12 && $data[12] ne "." ) { $zip->SetValue($data[12]) };
    if ( $currentLength > 6 && $data[6] ne "." ) { $email->SetValue($data[6]) };
    if ( $currentLength > 13 && $data[13] ne "." ) { $ptype->SetValue($data[13]) };
    if ( $currentLength > 7 && $data[7] ne "." ) { $refto->SetValue($data[7]) };
    if ( $currentLength > 17 && $data[17] ne "." ) { $refby->SetValue($data[17]) };
    if ( $currentLength > 14 && $data[14] ne "." ) { $mtype->SetValue($data[14]) };
    if ( $currentLength > 19 && $data[19] ne "." ) { $stat->SetValue($data[19]) };
    if ( $currentLength > 15 && $data[15] ne "." ) { $note->SetValue($data[15]) };
    
#   if ( $currentLength > 6 && $data[6] ne "." && $data[6] =~ /\d{3,}-\d\d-\d\d/) { $date->SetValue($data[6]) }; 
 my ($yy, $dd, $mm ) =  ParseInDate($data[8]);

 my $dateObj = Wx::DateTime->newFromDMY($dd,$mm-1,$yy, 1,1,1,1);
 my $tmpstr = $dateObj->Format;
 print " date = $data[8] \n  dateObj = $dateObj \n str = $tmpstr \n";
 if ( $currentLength > 8 && $data[8] ne "." ) { $refdate->SetValue($dateObj) }; 
 
  ($yy, $dd, $mm ) =  ParseInDate($data[22]);

  $dateObj = Wx::DateTime->newFromDMY($dd,$mm,$yy, 1,1,1,1);
  $tmpstr = $dateObj->Format;
 print " date = $data[22] \n  dateObj = $dateObj \n str = $tmpstr \n";

 
    if ( $currentLength > 22 && $data[22] ne "." ) { $orgdate->SetValue($dateObj) }; 
  
#    my $dialog = $self->xrc->LoadDialog( $parent || $self, 'dlg1' );
  }
    $dialog->ShowModal();
    print " exit - add - change dialog \n";
#    $dialog->Destroy;
}       

sub ParseInDate
{
    my $lclDate = shift;
    my $m;
    my $y;
    my $d;
 #   $lclDate =~ s{\/}{-}g;
    print " date mod: $lclDate \n";
    $m = substr($lclDate,4,2); 
    $y = substr($lclDate,0,4);
    $d = substr($lclDate,6,2);
 #   \d{3,}-\d\d-\d\d
  #  $date =~ /^(\d{4}) (\d{2}) (\d{2})\ (\d{2}):(\d{2})$/x;
#  my ($m,$d,$y) = $lclDate =~ /(\d+)-(\d+)-(\d+)/
  
  
#   or die;
   print " year = $y , month = $m, day = $d \n ";   
    return ($y, $d, $m );
}


sub ParseDate
{
    my $lclDate = shift;
    $lclDate =~ s{\/}{-}g;
    print " date mod: $lclDate \n";
 #   \d{3,}-\d\d-\d\d
 #  $date =~ /^(\d{4}) (\d{2}) (\d{2})\ (\d{2}):(\d{2})$/x;
 
 my ($m,$d,$y) = $lclDate =~ /(\d+)-(\d+)-(\d+)/
   or die;
   print " year = $y , month = $m, day = $d \n ";   
    return ($y, $d, $m );
}

sub Delete
{
	print "Del: $lclDBData[0] \n"; 
    show_delete(@lclDBData);         
}


sub OnUpdate {
    
     my $this = shift;
     use Wx qw(wxOK wxCENTRE);
     my $lastID = 0;

     my @dataArray = CreateString();
  
  
    
     my $dbfile = "leadmanagement.db";
     my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});
    
    
    
       my @data = @lclDBData;
  
      my $et = "-";

     
     
     
my $statement;
if  ( $data[0] > 0 )   
{
          
         print " in upt --- > $data[0] \n ";
         my $ind = 0;
         while ( $ind < 22 )
         {  
             print "val: $ind ---> $dataArray[$ind] <-----";
             $ind++;
         }
         print " \n";
         
         #if ($g_type == 2) { $et = "Imp";   }

	     my $tempe = join(" = ?, ",@dbColumns);
	                   
         $statement = "UPDATE LeadData SET " . $tempe . "= ? WHERE LeadID = ?"; 
        
         print "sql: $statement\n";        
         $dbh->do($statement, undef,  $dataArray[0], $dataArray[1],$dataArray[2],$dataArray[3],$dataArray[4],$dataArray[5], $dataArray[6],$dataArray[7],$dataArray[8],$dataArray[9],$dataArray[10],$dataArray[11],$dataArray[12],$dataArray[13],$dataArray[14],$dataArray[15],$dataArray[16],$dataArray[17],$dataArray[18],$dataArray[19],$dataArray[20],$dataArray[21],$et,$data[0]);
       
        
}
else
{
    
                 print " in add --- > $data[0] ---> type: $g_type  \n ";
    
    
    
    # sub - get index --- 
    
    
    
    
    
             my $tempez = join(", ", @dbColumns);
             my $sth = $dbh->prepare("select LeadID from LeadData order by LeadID desc limit 1");
    
    $sth->execute();
    while (
        my @result = $sth->fetchrow_array()) {
        print "id: $result[0]\n";
        $lastID = $result[0];
    }
    
    $sth->finish;
    $lastID++;
                     
     $statement = "INSERT INTO LeadData (LeadID, " . $tempez . ") VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
         print "sql-insert: $statement\n";        

     $dbh->do($statement, undef, $lastID, $dataArray[0], $dataArray[1],$dataArray[2],$dataArray[3],$dataArray[4], $dataArray[5], $dataArray[6],$dataArray[7],$dataArray[8],$dataArray[9],$dataArray[10],$dataArray[11],$dataArray[12],$dataArray[13],$dataArray[14],$dataArray[15],$dataArray[16],$dataArray[17],$dataArray[18],$dataArray[19],$dataArray[20],$dataArray[21],$et);
}

    $dbh->disconnect;
    # Refresh();
    
    Wx::MessageBox("_lbl1: $dataArray[0]\n $dataArray[1]\n(c) More On Perl",  # text
                   "About",                   # title bar
                   wxOK|wxCENTRE,             # buttons to display on form
                   $this                      # parent
                   );             
}

sub CreateString
{
    my @retArray;
    my $id;
    my $cnt = 0;
    my $yy;
    my $dd;
    my $mm;
    my $tdate;
    
         push(@retArray, $bname->GetValue());
         push(@retArray, $firstname->GetValue());
         push(@retArray, $lastname->GetValue());
         push(@retArray, $phone->GetValue());
         push(@retArray, $mphone->GetValue());
         push(@retArray, $email->GetValue()); 
         push(@retArray, $refto->GetValue());
              ($yy, $dd, $mm ) = ParseDate($refdate->GetValue()->FormatDate);
              $dd = "0". $dd unless length $dd > 1;
              $mm = "0" .$mm unless length $mm > 1;
              $tdate = $yy . $mm . $dd ; 
         push(@retArray, $tdate);

         push(@retArray, $address->GetValue());
         push(@retArray, $city->GetValue());
         push(@retArray, $state->GetValue());
         push(@retArray, $zip->GetValue());
         push(@retArray, $ptype->GetValue());
         push(@retArray, $mtype->GetValue());
         push(@retArray, $note->GetValue());
         push(@retArray, '.');   # org type
         push(@retArray, $refby->GetValue());
         push(@retArray, '.');   #  finance req
         push(@retArray, $stat->GetValue());
         push(@retArray, '.');   #  quote req 
         push(@retArray, '.');   #  quote other req
              ($yy, $dd, $mm ) = ParseDate($orgdate->GetValue()->FormatDate);
              $dd = "0". $dd unless length $dd > 1;
              $mm = "0" .$mm unless length $mm > 1;
              $tdate = $yy . $mm . $dd ; 
         push(@retArray, $tdate);
          
              print " <**> date: $tdate\n";   
   
   
  return @retArray;
}


sub Clear
{
    print "clear\n";
    $bname->ChangeValue("") ;
    $firstname->ChangeValue("");
    $lastname->ChangeValue("");
    $phone->ChangeValue("");  
    $city->ChangeValue(""); 
    $address->ChangeValue("");
    $state->SetValue("");
    $zip->SetValue("");
    $email->SetValue("");
    $ptype->SetValue("");
    $refto->SetValue("");
    $refby->SetValue("");
    $mtype->SetValue("");
    $stat->SetValue("");
    $note->SetValue("");
}

sub OnExport
{
    
    use YAML qw(LoadFile);

    my $settings = LoadFile('.\res\zohoEX.yaml');
    
    
my $emailAddr = ${$settings}[0];
my $dbName = ${$settings}[1];
my $tableName = ${$settings}[2];
my $authtoken = ${$settings}[3];
my $action = ${$settings}[4];
my $format = ${$settings}[5];
my $version = ${$settings}[6];

my $val1 = $lclDBData[0];

# Create a user agent
my $ua = LWP::UserAgent->new();
 
# URL for service (endpoint)
my $url =  'https://reportsapi.zoho.com/api/' . $emailAddr . '/' . $dbName . '/' . $tableName . '/';

# Populate POST data fields (key => value pairs)
my (%post_data) = (
                  'ZOHO_ACTION' => $action,
                  'ZOHO_OUTPUT_FORMAT' => $format,
                  'ZOHO_ERROR_FORMAT' => $format,
                   'authtoken' => $authtoken,
                   'ZOHO_API_VERSION' => $version,
                   'LeadID' => $val1,
                   'Lead_BusinessName' => $bname->GetValue(),
                   'Lead_FirstName' => $firstname->GetValue(),
                   'Lead_LastName' => $lastname->GetValue(),
                   'Lead_BusinessPhone' => $phone->GetValue(),
                   'Lead_MobilePhone' => $mphone->GetValue(),
                   'Lead_Email' => $email->GetValue(),
                   'Lead_Dealer_ReferedTo' => $refto->GetValue(),
                   'Lead_ReferalDate' => $refdate->GetValue(),
                  'Lead_Street' => $address->GetValue(),
                   'Lead_City' => $city->GetValue(),
                   'Lead_State' => $state->GetValue(),
                   'Lead_Zip' => $zip->GetValue(),
                   'Lead_Equipment_Type' => $ptype->GetValue(),
                  'Lead_Notes' => $note->GetValue(),
                   'Sales_Status' => 0,
                   'Sales_Quote' => 0
		   );
 
# Perform the request
my $response = $ua->post($url, \%post_data);
 
# Check for HTTP error codes
die 'http status: ' . $response->code . $response->content() . ' ' . $response->message unless ($response->is_success); 
 
# Output the entry
print $response->content();
  
UpdateExport();  
  
}

sub UpdateExport
{
     my $dbfile = "leadmanagement.db";
     my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});
    
    
    
       my @data = @lclDBData;
    
    
         print " in upt export --- > $data[0] \n ";
         my $ind = 0;
	     my $tempe = join(" = ?, ",@dbColumns);
	                   
        my $statement = "UPDATE LeadData SET Lead_Error_Type = ? WHERE LeadID = ?"; 
        
         $dbh->do($statement, undef, "Exp", $data[0]);

         $dbh->disconnect;

}

sub GetNote
{
#    use WxView qw($frame $xr  setNote);

#         WxView->new();
         

#    setNote(@lclDBData);
}

sub GetStat
{

    show_stats(@lclDBData);
}

sub Exit 
{ CloseWin(); 
} 
# 
# Close is not called by the menu, but is called to close all wind 
#         +ows 
# If there are any toplevel dialogs, close them here, otherwise th 
#               +e 
# program will not exit. 
# 
sub CloseWin 
{ 
   print "exit - wxaddchg\n";
   our $dialog->Destroy(); 
} 



1; 

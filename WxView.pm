package WxView; use base qw(Wx::App Exporter); 
# use Class::Date qw(:errors date localdate gmdate now -DateParse -EnvC);
use strict; 
use Exporter; 
our $VERSION = 0.10;
our @EXPORT_OK = qw(StartApp FindWindowByXid MsgBox $frame $xr show_add show_dialog %test_list 
$xrc $frmID $sbar %menu  $icon %txtctrl $dialog $frameGrid setNote) ; 
use Wx qw(wxDefaultPosition wxDefaultSize wxDP_ALLOWNONE); 
# use Wx::Grid;
use Carp; 
our $dialog; 
our $xr; 
#our $xrc = 'res/res.xrc'; # location of resource file 
our $xrc = './res/view1.xrc'; # location of resource file 

our $dialogID = 'MyDialogV'; # XML ID of the main frame 


# it is the routine called before the end 
# it needs to Destroy() all top level dialogs 
our $icon = Wx::GetWxPerlIcon(); 

# global
my $g_swt = 1;
my $g_type = 0;
my $g_id = 0;
my $g_sqlcount = 0;
my %g_note_hash;
my $g_current_page = 0;
my $g_total_page_count = 0;
my $g_paging = 0;
my %g_id_hash;
my $q_type = 0;

my $file; # the name of the file used in Open/Save
my %cntlHash = ();

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
    my $type;
    my $note;

# our $currentData;
     my $dbfile = "leadmanagement.db";
     my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});


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
   zip       $zip
 );


# debug - print " pm - frame = $frame \n";

my ( $idAdd) = FindWindowByXid('wxID_OK');
Wx::Event::EVT_BUTTON($dialog, $idAdd, \&setUPT );

my ($idCancel) = FindWindowByXid('btnCancel');
Wx::Event::EVT_BUTTON($dialog, $idCancel, sub { $_[0]->Close } );

my ($idLink0) = FindWindowByXid('m_hyperlink2');
 Wx::Event::EVT_HYPERLINK($dialog,$idLink0, \&Prev);

my ($idLink1) = FindWindowByXid('m_hyperlink3');
 Wx::Event::EVT_HYPERLINK($dialog,$idLink1, \&Next);

my ($idLink2) = FindWindowByXid('m_hyperlink4');
 Wx::Event::EVT_HYPERLINK($dialog,$idLink2, \&InsertNote);

my $ck_dialog = 0;
if ( $ck_dialog)
{
 our $dialogGrid = $xr->LoadDialog( $frame,  'MyDialog1' );
}

#our $frameGrid = $xr->LoadObject(undef, 'm_grid3', 'Wx::Grid');

 
if (my $sbar) 
{  
   $frame->CreateStatusBar( $sbar ); 
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
{ 
    my $id = Wx::XmlResource::GetXRCID($_[0], -2);
    return undef if $id == -2; 
    my $win = Wx::Window::FindWindowById($id, our $frame); 
    return wantarray ? ($win, $id) : $win; 
} 
sub MsgBox 
{ 
    use Wx qw (wxOK wxICON_EXCLAMATION); 
    my @args = @_; 
    $args[1] = 'Message' unless defined $args[1]; 
    $args[2] = wxOK | wxICON_EXCLAMATION unless defined $args[2]; 
    my $md = Wx::MessageDialog->new(our $frame, @args); 
   $md->ShowModal(); 
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
   
         my $currentLength = scalar @thisCurrentData;   
         my $intI = 0;
         $g_swt = 1;
#         while ($intI < $currentLength)
#        {
#             print " $intI: $thisCurrentData[$intI] \n";
#             $intI++;
#         }
   
   FindWindowByXid('tcOUT')->SetValue(buildTextString());
   FindWindowByXid('wxID_OK')->SetLabel("Note");
   FindWindowByXid('tbTxt')->SetValue(buildTxtBoxOut());
    $dialog->ShowModal();
    print " exit - add - change dialog \n";
#    $dialog->Destroy;
}     
  
 sub  setNote
 {
     my(@current) = @_;
     print "setNote - $g_swt\n";
     $g_current_page = 0;
     $g_id = $current[0];

    my $note_cnt = get_notecount();
    
         print "note: $current[15]\n -- note count:$note_cnt -- g_id: $g_id\n";

        
      
            $g_id_hash{"rec:0"} = $g_id;
            $g_note_hash{"rec:0"} = $current[15] ;
        
     if ( $note_cnt > 0 )
     {
         FindWindowByXid('m_hyperlink3')->SetLabel('next');
         FindWindowByXid('m_hyperlink2')->Enable();
         select_notes();
         $g_paging = 1;
         $g_total_page_count = $note_cnt;
     }     
     else
     {
#         FindWindowByXid('m_hyperlink3')->SetLabel('insert');
         FindWindowByXid('m_hyperlink2')->Disable();
         $g_paging = 0;
         $g_type = 0;
         $g_total_page_count = 0;
     }

      
                 FindWindowByXid('tbTxt')->SetValue(buildTxtBox());

     
         if ($g_swt == 1)
         {
          FindWindowByXid('tcOUT')->SetValue($current[15]);
   #       FindWindowByXid('wxID_OK')->SetLabel("Back");
   #       $g_swt = 0;
         }
         else
         {
           FindWindowByXid('tcOUT')->SetValue(buildTextString());
           FindWindowByXid('wxID_OK')->SetLabel("Note");
         }
         $dialog->ShowModal();
 } 
  
sub buildTxtBoxOut
{
    #my $page_no = check_pagecount()
    return "record detail";
}

sub buildTxtBox
{
    my $page_no = check_pagecount();
    return "Page $page_no of $g_total_page_count";
}

sub buildTextString
{
       $g_swt = 1;
	    my $outSTR1 = "bn: " . $lclDBData[1] . "  fn: " . $lclDBData[2] . "  ln: " . $lclDBData[3] . "  ph: " . $lclDBData[4] ;
        my $outSTR2 = "mph: " . $lclDBData[5] . "  em: " . $lclDBData[6] . "  refto: " . $lclDBData[7] . "  refdt: " . $lclDBData[8]; 
        my $outSTR3 = "st: " . $lclDBData[9] . "  city: " . $lclDBData[10] . "  st: " . $lclDBData[11] . "  zip: " . $lclDBData[12]; 
        my $outSTR4 = "eq: " . $lclDBData[13] . "  mdl: " . $lclDBData[14] . "  org: " . $lclDBData[16] . "  refby: " . $lclDBData[17]; 
        my $outSTR5 = "freq: " . $lclDBData[18] . "  stat: " . $lclDBData[19] . "  quote: " . $lclDBData[20] . "  other: " . $lclDBData[21]; 
        my $outSTR6 = "cdate: " . $lclDBData[22] . "  err: " . $lclDBData[23] ; 
         return ($outSTR1 . "\n" .$outSTR2 . "\n" .$outSTR3 . "\n" .$outSTR4 . "\n" .$outSTR5 . "\n" .$outSTR6 . "\n" );
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


sub CreateString
{
    my @retArray;
    my $id;
    my $cnt = 0;
    
   
  return @retArray;
}

sub Prev
{
    
   my $pageno = check_pagecount();
   
   print "Prev - pageno = $pageno of $g_total_page_count\n";   

     if ( $pageno > 0 ) 
    { 
        $pageno--;
         DisplayNote($pageno);
         dec_pagecount();  
    }
            FindWindowByXid('tbTxt')->SetValue(buildTxtBox());

 
}

sub Next
{
    my $pageno = check_pagecount();
    
    print "Next - pageno = $pageno of $g_total_page_count\n";    
    
    if ($pageno < $g_total_page_count)
    {
                   #
            $g_type = 2;
            $pageno++;
            DisplayNote( $pageno );
             print "* ";
         inc_pagecount(); 
    }

                FindWindowByXid('tbTxt')->SetValue(buildTxtBox());

 
    print " exit - Next - pageno = $pageno - total_page - $g_total_page_count - current = $g_current_page \n"; 
}

sub InsertNote
{

          FindWindowByXid('tcOUT')->SetValue('** new ** --');
           $g_type = 4;
           $q_type = 0;
           print ".i ";

}


sub DisplayNote
{
        my $pageno = shift;
        my $thing = "rec:$pageno";
        FindWindowByXid('tcOUT')->SetValue($g_note_hash{$thing});
 }


sub check_pagecount
{
    return $g_current_page;
}

sub dec_pagecount
{
    $g_current_page--;
}

sub inc_pagecount
{
    $g_current_page++;
}

sub setUPT
{
    
     print " setUPT -- g_type = $g_type ?\n";    
    if ($g_type == 0 )
    {
        update_leaddata_note();
    }
    else
    {
        if($g_type == 1)
        {
             update_notes();            
        }
        else
        {
            if($g_type == 4)
            {
                insert_notes();
                update_leaddata_note();
                $g_total_page_count++;
            }
            else
            {
                if(($g_type == 2) && ($g_current_page > 0 ))
                {#  can not reach here ?
                         update_notes();
                }
                else
                {
                    update_leaddata_note();
                }                #  can not reach here ?
            }
        }
    }
}


sub update_notes
{
    
      my $note = FindWindowByXid('tcOUT')->GetValue();

      my $page_no =  $g_current_page;
      my $thing = "rec:$page_no";
      my $note_id = $g_id_hash{$thing};        
         
         
      print "current_page: $page_no ....";    
      print "update_notes - g_id: $g_id -- note_id: $note_id note: $note \n";   
    
     #my (@ckarray) = @_;      
     my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});

      print " update stats - id: $g_id\n";
# 	  my $tempe = join(" = ?, ",@dbColums);
      
     my   $statement = "UPDATE Note SET Note = ? WHERE Lead_ID = ? and Note_ID = ?"; 
	                   
#        $statement = "UPDATE LeadStats SET " . $tempe . "= ?, Contact_Notes = ? WHERE statLeadLnk = ?"; 
       $dbh->do($statement, undef, $note,  $g_id, $note_id);
       $dbh->disconnect;

}

sub get_note_id
{
    return $g_id_hash{$g_current_page};
}

sub update_leaddata_note
{
    
            my $note = FindWindowByXid('tcOUT')->GetValue();
    
    
      print "update_leaddata_note:\n";
      print "g_id: $g_id -- note: $note\n";
    
         my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});

         my   $statement = "UPDATE LeadData SET Lead_Notes = ? WHERE LeadID = ? "; 
	                   
#        $statement = "UPDATE LeadStats SET " . $tempe . "= ?, Contact_Notes = ? WHERE statLeadLnk = ?"; 
       $dbh->do($statement, undef, $note,  $g_id);
       $dbh->disconnect;

}

sub insert_notes
{
    print "insert_notes -- \n";       
    
    my @dataArray = switch_current(1);
    
    print " g_id: $dataArray[0] -- note: $dataArray[1] \n";    
    
    my $lastID;
         my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});

    my $sth = $dbh->prepare("select Note_ID from Note order by Note_ID desc limit 1");
    $sth->execute();
    while (
        my @result = $sth->fetchrow_array()) {
        print "id: $result[0]\n";
        $lastID = $result[0];
    }
    $sth->finish;
    $lastID++;
    my $statement = "INSERT INTO Note (Note_ID, Lead_ID, Note ) VALUES(?, ?, ?)";
    
         $dbh->do($statement, undef, $lastID, $dataArray[0], $dataArray[1]);
     $dbh->disconnect;
}

sub get_notecount
{
    print "get_notecount\n";
         my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});

      $g_sqlcount =  " SELECT COUNT(*)  FROM Note where Lead_ID = '$g_id'";
      my ($count) = $dbh->selectrow_array($g_sqlcount);
      return $count;

}

sub select_notes
{
    
    print "select_notes - g_id: $g_id\n";
    
    my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});

    my             $sqlselect = " SELECT * from Note where Lead_ID = '$g_id' ";
                   my $sth = $dbh->prepare($sqlselect);
    $sth->execute();

    my $cnt_row = 0;
    my $cnt_col = 0;
#    my %note_hash;
    my $thing;
    my $i = 1;
    while (my @result = $sth->fetchrow_array()) {
            print ". ";
            $thing = "rec:$i";
            print ". $thing ---> $result[1]\n";
            $g_id_hash{$thing} = $result[0];
            $g_note_hash{$thing} = $result[2] ;
            $i++;
    } 

}

sub switch_current
{
    print "switch_current:g_id -> $g_id\n";
    my $thing_swt = shift;
    my $current_hash_id = $g_id_hash{"rec:0"};
    my $current_note = $g_note_hash{"rec:0"};
    print "current_hash_id:$current_hash_id --- current_note:$current_note\n";
           $g_id_hash{"rec:0"} = -1;
            $g_note_hash{"rec:0"} = FindWindowByXid('tcOUT')->GetValue() ;
            $g_note_hash{"rec:$g_current_page"} = $current_note;
#            $g_id_hash{"rec:$g_current_page"} = $current_hash_id;
            if ($thing_swt == 1) {return ($current_hash_id,$current_note)}; 
            
}

sub Exit 
{ 
 CloseWin(); 
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
  $dialog->Destroy(); 
} 
1; 

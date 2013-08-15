package WxStats; use base qw(Wx::App Exporter); 
# use Class::Date qw(:errors date localdate gmdate now -DateParse -EnvC);
use strict; 
use Exporter; 
#use DBI          qw();

our $VERSION = 0.10;
our @EXPORT_OK = qw(
$frame $xr show_stats  $currentData $xrc $CloseWin
 ) ; 
use Wx; 
use Wx::Grid;
use Carp; 
our $dialog; 
our $xr; 
#our $xrc = 'res/res.xrc'; # location of resource file 
our $xrc = '.\\res\\xrc_stats_dialog.xrc'; # location of resource file 

our $dialogID = 'MyDialogS'; # XML ID of the main frame 
   my @lclDBData;
our $CloseWin = \&CloseWin; # this is not a menu option
# it is the routine called before the end 
# it needs to Destroy() all top level dialogs 
our $icon = Wx::GetWxPerlIcon(); 
my $file; # the name of the file used in Open/Save 
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
# debub - print " pm - frame = $frame \n";
my ($idDelete) = FindWindowByXid('btnUpt');
Wx::Event::EVT_BUTTON($dialog, $idDelete, \&OnUpdate );

my ($idCancel) = FindWindowByXid('btnCancel');
Wx::Event::EVT_BUTTON($dialog, $idCancel, sub { $_[0]->Close } );


 
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

       my $found = 0;
       my $g_id;
#     my @settings;
 

 
  	 my @dbColums =          qw(statID 
                                 statLeadLnk  
                                 stat_question1  
                                 stat_value1  
                                 stat_question2  
                                 stat_value2  
                                 stat_question3  
                                 stat_value3  
                                 stat_question4  
                                 stat_value4  
                                 stat_question5  
                                 stat_value5  
                                 stat_question6  
                                 stat_value6  
                                 stat_question7  
                                 stat_value7  
                                 stat_question8  
                                 stat_value8  
                                 stat_misc  
                                 stat_question_cnt  
                                stat_value);
                                
                                
           my @dbColumz =          qw(statID 
                                 statLeadLnk  
                                 stat_value1  
                                 stat_value2  
                                 stat_value3  
                                 stat_value4  
                                 stat_value5  
                                 stat_value6  
                                 stat_value7  
                                 stat_value8); 
                                 
                                
sub append_questions
{
    use YAML qw(LoadFile);

    my @settings = LoadFile('.\res\q.yaml');
    my    $lb1 = FindWindowByXid('lb1');
    my    $lb2 = FindWindowByXid('lb2');
    my    $lb3 = FindWindowByXid('lb3');
    my    $lb4 = FindWindowByXid('lb4');
    my    $lb5 = FindWindowByXid('lb5');
    my    $lb6 = FindWindowByXid('lb6');
    my    $lb7 = FindWindowByXid('lb7');
    my    $lb8 = FindWindowByXid('lb8');

print "lb1 -> $lb1\n";

#    my $dialog = $self->xrc->LoadDialog( $parent || $self, 'dlg1' );
#  if ( $currentLength > 1 && $data[1] ne ".") {  $bname->ChangeValue($data[1]) } else { $bname->ChangeValue("")} ;
#   if ( $currentLength > 2 && $data[2] ne ".") {  $firstname->ChangeValue($data[2]) } else { $firstname->ChangeValue("")} ;
 $lb1->SetLabel($settings[0][0]);
 $lb2->SetLabel($settings[0][1]);
 $lb3->SetLabel($settings[0][2]);
 $lb4->SetLabel($settings[0][3]);
 $lb5->SetLabel($settings[0][4]);
 $lb6->SetLabel($settings[0][5]);
 $lb7->SetLabel($settings[0][6]);
 $lb8->SetLabel($settings[0][7]);
}                               
                                
  sub show_stats {
#    my( $self, $event, $parent ) = @_;
    my(@current) = @_;
      print "id: $current[0]\n";
    my $inID = $current[0] . ":" . $current[2] . ":"  . $current[3];
    append_questions();

#    my    $id = FindWindowByXid('tbID');
#   my    $notes = FindWindowByXid('tbNotes');
#    my $dialog = $self->xrc->LoadDialog( $parent || $self, 'dlg1' );
#  if ( $currentLength > 1 && $data[1] ne ".") {  $bname->ChangeValue($data[1]) } else { $bname->ChangeValue("")} ;
#   if ( $currentLength > 2 && $data[2] ne ".") {  $firstname->ChangeValue($data[2]) } else { $firstname->ChangeValue("")} ;
# $id->ChangeValue($inID);
# $notes->ChangeValue($current[15]);
;

      select_stats($current[0]);


    $dialog->ShowModal();
#    $dialog->Destroy;
}     

sub select_stats
{
#        sub - get index --- 
     my $id = shift;
     
     
my $cb1 = FindWindowByXid('m_checkBox1');
my $cb2 = FindWindowByXid('m_checkBox2');
my $cb3 = FindWindowByXid('m_checkBox3');
my $cb4 = FindWindowByXid('m_checkBox4');
my $cb5 = FindWindowByXid('m_checkBox5');
my $cb6 = FindWindowByXid('m_checkBox6');
my $cb7 = FindWindowByXid('m_checkBox7');
my $cb8 = FindWindowByXid('m_checkBox8');
     
     $cb1->SetValue(0);
     $cb2->SetValue(0);
     $cb3->SetValue(0);
     $cb4->SetValue(0);
     $cb5->SetValue(0);
     $cb6->SetValue(0);
     $cb7->SetValue(0);
     $cb8->SetValue(0);
     
     my $dbfile = "leadmanagement.db";
     my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});
     $found = 1;

             my $tempez = join(", ", @dbColumz);
#      $statement = "INSERT INTO ContactData (ContactID, Contact_BusinessName, Contact_FirstName, Contact_LastName, Contact_Street, Contact_City, Contact_State, Contact_ContactDate) VALUES(?, ?, ?, ?, ?, ?, ?, ?)";

        my $sql = "SELECT " . $tempez . " FROM LeadStats WHERE statLeadLnk=?";
        
        my @row = $dbh->selectrow_array($sql,undef,$id);
                 unless (@row) { $found = 0; }
             $dbh->disconnect;

        print " sql - $sql\n"; 
        print " select stats: $id -fnd:$found\n";
 #       print " statLnkID = $row[1] - $row[2]\n";
 #       print " val2 - $row[3]\n";
        $g_id = $id;        
        
        
     if ($found)
     {
         if ( defined $row[2] )
         {
            $cb1->SetValue(1) unless $row[2] == 0;
         }   
         if ( defined $row[3] )
         {
            $cb2->SetValue(1) unless $row[3] == 0;
         }
         if ( defined $row[4] )
         { 
            $cb3->SetValue(1) unless $row[4] == 0;
         }
         if ( defined $row[5] )
         {
            $cb4->SetValue(1) unless $row[5] == 0;
         }
         if ( defined $row[6] )
         {
            $cb5->SetValue(1) unless $row[6] == 0;
         }   
         if ( defined $row[7] )
         { 
            $cb6->SetValue(1) unless $row[7] == 0;
         }
         if ( defined $row[8] )
         {
             $cb7->SetValue(1) unless $row[8] == 0;
         
         }
         if ( defined $row[9] )
         {    
             $cb8->SetValue(1) unless $row[9] == 0;
         }    
     }

#    $sth->finish;
}

sub OnUpdate
{
    
    my $cb1 = FindWindowByXid('m_checkBox1');
my $cb2 = FindWindowByXid('m_checkBox2');
my $cb3 = FindWindowByXid('m_checkBox3');
my $cb4 = FindWindowByXid('m_checkBox4');
my $cb5 = FindWindowByXid('m_checkBox5');
my $cb6 = FindWindowByXid('m_checkBox6');
my $cb7 = FindWindowByXid('m_checkBox7');
my $cb8 = FindWindowByXid('m_checkBox8');
    

my @checkarray;

     my $cnt = 0;
     while ($cnt < 8 )
     {
         $checkarray[$cnt] = 1;
         $cnt++;
     }

    $checkarray[0] = 0 unless $cb1->IsChecked() ;
    $checkarray[1] = 0 unless $cb2->IsChecked() ; 
    $checkarray[2] = 0 unless $cb3->IsChecked() ;
    $checkarray[3] = 0 unless $cb4->IsChecked() ; 
    $checkarray[4] = 0 unless $cb5->IsChecked() ;
    $checkarray[5] = 0 unless $cb6->IsChecked() ; 
    $checkarray[6] = 0 unless $cb7->IsChecked() ;
    $checkarray[7] = 0 unless $cb8->IsChecked() ; 


    if ($found)
    {
          update_stats(@checkarray);        
    }
    else
    {
          insert_stats(@checkarray);        
    }
}



sub insert_stats
{
    my (@ckarray) = @_;
    
  	 my @dbColumns =          qw(statID 
                                 statLeadLnk  
                                 stat_value1  
                                 stat_value2  
                                 stat_value3  
                                 stat_value4  
                                 stat_value5  
                                 stat_value6  
                                 stat_value7  
                                 stat_value8  
                                 stat_misc);  
    
    
    
    
    my $lastID = 0;
    
    my $cnt = 0;
         while ($cnt < 8 )
         {
             print "cnt: $cnt ---> $ckarray[$cnt]\n";
             $cnt++;
         }
    
     my $dbfile = "leadmanagement.db";
     my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});

     my $sth = $dbh->prepare("select statID from LeadStats order by statID desc limit 1");
    $sth->execute();
    while (
        my @result = $sth->fetchrow_array()) {
        print "id: $result[0]\n";
        $lastID = $result[0];
    }
    $sth->finish;
    $lastID++;  
    
 	  my $tempe = join(", ",@dbColumns);
    
      print " - tempe: $tempe\n";
      
    my $statement = "INSERT INTO LeadStats ($tempe ) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    $dbh->do($statement, undef, $lastID, $g_id, $ckarray[0],$ckarray[1],$ckarray[2],$ckarray[3],$ckarray[4], $ckarray[5], $ckarray[6],$ckarray[7],"**");
    $dbh->disconnect;
}

sub update_stats
{
     my (@ckarray) = @_;      
     my $dbfile = "leadmanagement.db";
     my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});

      print " update stats - id: $g_id\n";
# 	  my $tempe = join(" = ?, ",@dbColums);
      
     my   $statement = "UPDATE LeadStats SET stat_value1 = ?, stat_value2 = ?, stat_value3= ?, stat_value4 = ?, stat_value5 = ?, stat_value6 = ?, stat_value7 = ?, stat_value8 = ? WHERE statLeadLnk = ?"; 
	                   
#        $statement = "UPDATE LeadStats SET " . $tempe . "= ?, Contact_Notes = ? WHERE statLeadLnk = ?"; 
       $dbh->do($statement, undef, $ckarray[0], $ckarray[1],$ckarray[2],$ckarray[3],$ckarray[4],$ckarray[5], $ckarray[6],$ckarray[7], $g_id);
       $dbh->disconnect;
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
   print " exit - wxstats\n";
    $dialog->Destroy(); 
} 
1;
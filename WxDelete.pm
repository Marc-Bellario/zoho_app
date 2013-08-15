package WxDelete; use base qw(Wx::App Exporter); 
# use Class::Date qw(:errors date localdate gmdate now -DateParse -EnvC);
use strict; 
use Exporter; 
our $VERSION = 0.10;
our @EXPORT_OK = qw(
$frame $xr show_delete  $currentData $xrc $CloseWin
 ) ; 
use Wx; 
use Wx::Grid;
use Carp; 
our $dialog; 
our $xr; 
#our $xrc = 'res/res.xrc'; # location of resource file 
our $xrc = '.\\res\\xrc_delete_dialog.xrc'; # location of resource file 

our $dialogID = 'MyDialog2'; # XML ID of the main frame 
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
my ($idDelete) = FindWindowByXid('btnOK');
Wx::Event::EVT_BUTTON($dialog, $idDelete, \&OnDelete );

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
 


sub show_delete {
    my(@tmpDBData ) = @_;
   @lclDBData = @tmpDBData;
#    my $dialog = $self->xrc->LoadDialog( $parent || $self, 'dlg1' );

my ($idLabel) = FindWindowByXid('m_staticText14');
         $idLabel->SetLabel("id: $tmpDBData[0]\n fname: $tmpDBData[2]\n lname: $tmpDBData[3]\n");

    $dialog->ShowModal();
#    $dialog->Destroy;
}       


sub show_dialog {
#    my( $self, $event, $parent ) = @_;
   my ($type) = @_;
    $dialog->ShowModal();
    print " exit - dialog \n";
#    $dialog->Destroy;
}       

sub OnDelete {
    my $this = shift;
    use Wx qw(wxOK wxCENTRE);
        my @data = @lclDBData;

      print " Enter Delete sub \n ";
         
    my $dbfile = "leadmanagement.db";
    my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});
     
my $statement = "DELETE FROM LeadData WHERE LeadID=" . $data[0] ;

    $dbh->do($statement);
    
 $statement = "DELETE FROM Note WHERE Lead_ID=" . $data[0] ;

    $dbh->do($statement);
    
 $statement = "DELETE FROM LeadStats WHERE statLeadLnk=" . $data[0] ;

    $dbh->do($statement);

    $dbh->disconnect;
    # Refresh();
    
    Wx::MessageBox("_lbl1: $data[0]\n $data[1]\n(c)More On Perl",  # text
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
     print "exit - wxdelete\n";
    our $dialog->Destroy(); 
} 
1; 

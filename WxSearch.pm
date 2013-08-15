package WxSearch; use base qw(Wx::App Exporter); 
# use Class::Date qw(:errors date localdate gmdate now -DateParse -EnvC);
use strict; 
use Exporter; 
our $VERSION = 0.10;
our @EXPORT_OK = qw(StartApp FindWindowByXid MsgBox $frame $xr show_search show_dialog 
%test_list $currentData $xrc $Exit $CloseWin
 ) ; 
# use WxPackage1;
use Wx; 
use Wx::Grid;
use Carp; 
our $dialog; 
our $xr; 
#our $xrc = 'res/res.xrc'; # location of resource file 
our $xrc = '.\\res\\xrc_search_dialog.xrc'; # location of resource file 

our $dialogID = 'MyDialog3'; # XML ID of the main frame 

#global
our $CloseWin = \&CloseWin; # this is not a menu option
my $g_state;
my $g_name;
my $g_type;

my $g_typeswt;
my $g_crit;




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
my ($idSearch) = FindWindowByXid('btnSearch');
Wx::Event::EVT_BUTTON($dialog, $idSearch, \&OnSearch );

my ($idCancel) = FindWindowByXid('btnCancel');
#Wx::Event::EVT_BUTTON($dialog, $idCancel, sub { $_[0]->Close } );

Wx::Event::EVT_BUTTON($dialog, $idCancel, \&Exit );

append_combos();

          my ($idType) = FindWindowByXid('ckType');
          my ($idState) = FindWindowByXid('ckState');
          my ($idName) = FindWindowByXid('ckName');
          my ($idDate) = FindWindowByXid('ckDateBefore');
          my ($idDate2) = FindWindowByXid('ckDateAfter');

#   enable controls on start 
             $idName->SetValue(0);
             $idState->SetValue(0);
             $idType->SetValue(0);
           FindWindowByXid('ckType')->Enable();
           FindWindowByXid('ckState')->Enable();   
           FindWindowByXid('ckName')->Enable();
            
#  disable date for release 1          
          FindWindowByXid('ckDateBefore')->Enable();
          FindWindowByXid('ckDateAfter')->Enable();

 Wx::Event::EVT_CHECKBOX($dialog,$idType,\&disableFromType);
 
 Wx::Event::EVT_CHECKBOX($dialog,$idState,\&disableFromState);

 Wx::Event::EVT_CHECKBOX($dialog,$idName,\&disableFromName);
  
 Wx::Event::EVT_CHECKBOX($dialog,$idDate,\&disableFromDate);
    
 Wx::Event::EVT_CHECKBOX($dialog,$idDate2,\&disableFromDate);



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
 
    my    $state = FindWindowByXid('cbStates');
    my    $stat = FindWindowByXid('cbType');
 
    my $len = @settingsA; 
 
    print " append_combos state len: $len\n";  
 #    print " --- state combo - $state\n";
  
my $i = 0;  
my $cnt = 0;  
  
      foreach my $r (@settingsA)
      {
             $stat->Append($r);
             $i++;
      }
       
       $cnt = $i;
       $i = 0 ;
        print "cnt:$cnt\n";       
       
      foreach my $s (@settings)
      {
             $state->Append($s);
             $i++;
      }
          $cnt = $i;
          print "cnt:$cnt\n"; 
}                               


sub  disableFromType
{
         print "disable for type\n";
         if ( FindWindowByXid('ckType')->IsChecked)
         {
               FindWindowByXid('ckState')->Disable();
               FindWindowByXid('ckName')->Disable();
               FindWindowByXid('ckDateBefore')->Disable();
               FindWindowByXid('ckDateAfter')->Disable();
         }
         else
         {
               FindWindowByXid('ckState')->Enable();
               FindWindowByXid('ckName')->Enable();
               FindWindowByXid('ckDateBefore')->Enable();
               FindWindowByXid('ckDateAfter')->Enable();
         }
}

sub disableFromName
{
          if ( FindWindowByXid('ckName')->IsChecked)
          {
              FindWindowByXid('ckType')->Disable();
              FindWindowByXid('ckState')->Disable();
              FindWindowByXid('ckDateBefore')->Disable();
              FindWindowByXid('ckDateAfter')->Disable();
         }
         else
         {
              FindWindowByXid('ckType')->Enable();
              FindWindowByXid('ckState')->Enable();
              FindWindowByXid('ckDateBefore')->Enable();
              FindWindowByXid('ckDateAfter')->Enable();              
         }
}

sub disableFromState
{
          print "disable for state\n";   
          if ( FindWindowByXid('ckState')->IsChecked)
          {
              FindWindowByXid('ckType')->Disable();
              FindWindowByXid('ckName')->Disable();
              FindWindowByXid('ckDateBefore')->Disable();
              FindWindowByXid('ckDateAfter')->Disable();
         }
         else
         {
              FindWindowByXid('ckType')->Enable();
              FindWindowByXid('ckName')->Enable();
              FindWindowByXid('ckDateBefore')->Enable();
              FindWindowByXid('ckDateAfter')->Enable();              
         }
}

sub disableFromDate
{
          print "disable for date\n";   
          if ( ( FindWindowByXid('ckDateBefore')->IsChecked) || (FindWindowByXid('ckDateAfter')->IsChecked) )
          {
              FindWindowByXid('ckType')->Disable();
              FindWindowByXid('ckName')->Disable();
              FindWindowByXid('ckState')->Disable();
         }
         else
         {
              FindWindowByXid('ckType')->Enable();
              FindWindowByXid('ckName')->Enable();
              FindWindowByXid('ckState')->Enable();
         }
}

sub show_search {
    my( $self, $event, $parent ) = @_;

#    my $dialog = $self->xrc->LoadDialog( $parent || $self, 'dlg1' );
    $dialog->ShowModal();
#    $dialog->Destroy;
        Exit();
        print " show_search : type->$g_typeswt ---- crit: $g_crit\n";
       return ($g_typeswt, $g_crit);
}       


sub show_dialog {
#    my( $self, $event, $parent ) = @_;
   my ($type) = @_;
    $dialog->ShowModal();
    print " exit - dialog \n";
#    $_[0]->Close
#    $dialog->Destroy;
}    
   
sub OnSearch {
    print " in search routine\n";
    my $type = settype();
    my $crit;
    $g_typeswt = $type;
    
    
    my $yy;
    my $dd;
    my $mm;
    my $tdate;
    my $tdate2;
    
    
    if ($type == 1) {
           $g_state = FindWindowByXid('cbStates')->GetValue();
           $g_crit = $g_state;
    }      
    else
    {
            if ($type == 2) {
                   $g_name = FindWindowByXid('tbName')->GetValue();
                   $g_crit = $g_name;
            }      
            else
            {
                   if ($type == 3) {
                        $g_type = FindWindowByXid('cbType')->GetValue();
                        $g_crit = $g_type;
                   }    
                   else
                   {
                        if ($type == 4) {
        #                     $g_type = FindWindowByXid('m_datePicker2')->GetValue();
                              ($yy, $dd, $mm ) = ParseDate(FindWindowByXid('m_datePick02')->GetValue()->FormatDate);
                              $dd = "0". $dd unless length $dd > 1;
                              $mm = "0" .$mm unless length $mm > 1;
                              $tdate = $yy . $mm . $dd ; 
                              ($yy, $dd, $mm ) = ParseDate(FindWindowByXid('m_datePick03')->GetValue()->FormatDate);
                              $dd = "0". $dd unless length $dd > 1;
                              $mm = "0" .$mm unless length $mm > 1;
                              $tdate2 = $yy . $mm . $dd ; 
                              $g_crit = $tdate .  $tdate2 ;
                        }
                        else
                        {
                            if ($type == 5) {
                               ($yy, $dd, $mm ) = ParseDate(FindWindowByXid('m_datePick02')->GetValue()->FormatDate);
                               $dd = "0". $dd unless length $dd > 1;
                               $mm = "0" .$mm unless length $mm > 1;
                               $tdate = $yy . $mm . $dd ; 
                               $g_crit = $tdate;
                            }      
                            else
                            {
                               if ($type == 6) {
                                 ($yy, $dd, $mm ) = ParseDate(FindWindowByXid('m_datePick03')->GetValue()->FormatDate);
                                 $dd = "0". $dd unless length $dd > 1;
                                 $mm = "0" .$mm unless length $mm > 1;
                                 $tdate = $yy . $mm . $dd ; 
                                 $g_crit = $tdate;
                               }      
                            }   
                        }      
                    }
            }
    } 
    print "state: $g_state ---- crit: $g_crit\n";
  Exit();
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

sub settype
{         
          my $type;
          my $swt_type = FindWindowByXid('ckType')->GetValue();
          my $swt_state = FindWindowByXid('ckState')->GetValue();
          my $swt_name = FindWindowByXid('ckName')->GetValue();
          my $swt_date_before = FindWindowByXid('ckDateBefore')->GetValue();
          my $swt_date_after = FindWindowByXid('ckDateAfter')->GetValue();
          
          print " state-swt: $swt_state\n";
          print  " name-swt: $swt_name\n";
          print "type-swt: $swt_type\n";
          
         if ( $swt_type ==1) { $type = 3; }   else
          {   if ( $swt_state == 1 ) { $type = 1; } else 
          {   if ( $swt_name == 1) {  $type = 2; } else
          {   if (($swt_date_before == 1) && ($swt_date_after == 1)) { $type = 4; } else
          {  if ($swt_date_before == 1)  { $type = 5; } else
          { $type = 6; }}}}}
          
         print "type:$type\n";
         return $type;
}



sub CreateString
{
    my @retArray;
    my $id;
    my $cnt = 0;
    
}


sub Exit 
{ 
 print "search exit\n";
  $dialog->Close; 
} 
# 
# Close is not called by the menu, but is called to close all windows 
#         
# If there are any toplevel dialogs, close them here, otherwise the 
#               
# program will not exit. 
# 
sub CloseWin 
{ 
  print "exit - wxsearch\n";
 our $dialog->Destroy(); 
} 
1; 

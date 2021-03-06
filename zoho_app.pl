#!/usr/bin/perl -w -- 
# generated by wxGlade 0.6.5 (standalone edition) on Fri Jan 11 14:59:42 2013
# To get wxPerl visit http://wxPerl.sourceforge.net/

use FindBin;
use lib "$FindBin::Bin";

#use lib "C:\\Documents and Settings\\will\\Desktop\\projects\\contact_app";
use Wx 0.15 qw[:allclasses];
use strict;
use Wx::Grid;
package MyFrame;

#use Wx qw[:everything];

use Wx qw[:button :textctrl :statictext :menu :sizer :misc :frame
          wxDefaultPosition
          wxDefaultSize
          wxDefaultValidator
          wxDEFAULT_DIALOG_STYLE
          wxID_CLOSE
          wxID_OK
          wxOK
          wxGridSelectCells
          wxGridSelectRows
          wxRESIZE_BORDER
          wxTE_MULTILINE];

use Wx::Event qw(EVT_NOTEBOOK_PAGE_CHANGED EVT_GRID_LABEL_LEFT_CLICK EVT_GRID_LABEL_LEFT_DCLICK EVT_MENU);
use base qw(Wx::Frame);
use strict;
use warnings;
use DBI          qw();

use WxAddChg qw(StartApp   $frame $xr show_add show_dialog %test_list 
$xrc $frmID $sbar %menu  $CloseWin $icon %txtctrl $dialog $frameGrid ) ;

use WxDelete qw($frame $xr show_delete  $currentData $xrc $CloseWin );
use WxSearch qw($frame $xr show_search $Exit $CloseWin);
#use WxNotes qw($frame $xr show_note $currentData $xrc $CloseWin $dialog);
use WxView qw($frame $xr  setNote);
use ZohoImport qw(new get_data ImportNewData);

#use WxStats qw($frame $xr show_stats $currentData $xrc $CloseWin);
my $currentDBData;
my $dbfile = "leadmanagement.db";
my @currentDataRow;
# global search
my $search_state;
my $g_sqlcount;
my $g_sqlselect;

my @g_grid_id_array1;
my @g_grid_id_array2;
my @g_grid_id_array3;


my $g_table;
#global --- other
my $g_self; 
my $g_refresh = 0;
my $g_data_set = 0;
my $g_data_get = 0;
my $g_page = 0;
    my $g_cnt_row1 = 0;
    my $g_cnt_row2 = 0;
    my $g_cnt_row3 = 0;

		my @dbColums =          qw(LeadID 
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
	                   
	          my $tmpe = join(",",@dbColums);       

sub new {
	my( $self, $parent, $id, $title, $pos, $size, $style, $name ) = @_;
	$parent = undef              unless defined $parent;
	$id     = -1                 unless defined $id;
	$title  = ""         unless defined $title;
	$pos    = wxDefaultPosition  unless defined $pos;
	$size   = wxDefaultSize      unless defined $size;
	$name   = ""                 unless defined $name;

        

#                begin wxGlade: MyFrame::new

	$style = wxDEFAULT_FRAME_STYLE 
		unless defined $style;

	$self = $self->SUPER::new( $parent, $id, $title, $pos, $size, $style, $name );
#	$self->{grid_1} = Wx::Grid->new($self, -1);
         
#                create dialog

         our $frame = $self;
         our $currentIndex = 0;
         our $Refresh = \&Refresh;
         
#    debug         print "script frame = $frame \n";

         WxAddChg->new();
         WxDelete->new();
         WxSearch->new();	
           WxView->new();        
#                  Menu Bar

	$self->{frame_1_menubar} = Wx::MenuBar->new();
	my $wxglade_tmp_menu;
	my $menu = Wx::Menu->new();
	my $menu2 = Wx::Menu->new();
	my $menu3 = Wx::Menu->new();
	
	$menu->Append(102, "Refresh" );
	$menu->Append( wxID_CLOSE, "Exit" );
	$menu2->Append( 101, "Add" );

	$menu2->Append( 103, "Delete" );
        $menu2->Append( 104, "Search" );
	$menu2->Append(105, "Notes" );
#	$menu2->Append(106, "Stats" );
	
	$menu3->Append(107,"Import");
	
	$self->{frame_1_menubar}->Append($menu, "file");
	$self->{frame_1_menubar}->Append($menu2, "dialog");
	$self->{frame_1_menubar}->Append($menu3, "data");


	
	$self->SetMenuBar($self->{frame_1_menubar});

#	EVT_MENU( $self, wxID_CLOSE, sub { \&OnQuit;$_[0]->Close; $frame->Destroy(); } );

        EVT_MENU( $self, wxID_CLOSE, \&OnQuit );


#	EVT_MENU( $self, wxID_CLOSE, sub { $_[0]->Close; $self->Destroy() } );


	EVT_MENU( $self, 101, \&add_dialog );
	EVT_MENU( $self, 102, \&Refresh );
	EVT_MENU( $self, 103, \&Delete );
	EVT_MENU( $self, 104, \&Search );
        EVT_MENU( $self, 105, \&Notes );
#        EVT_MENU( $self, 106, \&Stats );
        EVT_MENU( $self, 107, \&Importer );

	
#                     Menu Bar end

	$self->{notebook_1} = Wx::Notebook->new($self, -1, wxDefaultPosition, wxDefaultSize, 0);
	$self->{notebook_1_pane_1} = Wx::Panel->new($self->{notebook_1}, -1, wxDefaultPosition, wxDefaultSize, );
	$self->{notebook_1_pane_2} = Wx::Panel->new($self->{notebook_1}, -1, wxDefaultPosition, wxDefaultSize, );
 	$self->{notebook_1_pane_3} = Wx::Panel->new($self->{notebook_1}, -1, wxDefaultPosition, wxDefaultSize, );
 
        $self->{grid_1} = Wx::Grid->new($self->{notebook_1_pane_1}, -1);
        $self->{grid_2} = Wx::Grid->new($self->{notebook_1_pane_2}, -1);
        $self->{grid_3} = Wx::Grid->new($self->{notebook_1_pane_3}, -1);

   	$self->{grid_2}->CreateGrid(10, 6);
	$self->{grid_2}->SetSelectionMode(wxGridSelectCells);

    	$self->{grid_3}->CreateGrid(10, 6);
	$self->{grid_3}->SetSelectionMode(wxGridSelectCells);

        $g_self = $self;
 
        EVT_NOTEBOOK_PAGE_CHANGED( $self,$self->{notebook_1}->GetId(),\&tab_select );

	$self->__set_properties();
	$self->__do_layout();

#                          end wxGlade

	return $self;

}


sub __set_properties {
	my $self = shift;

# begin wxGlade: MyFrame::__set_properties
    my @grid_id_array;
     @g_grid_id_array1 = @grid_id_array;
#  SetHeading();
  Init() unless $g_refresh;
      
  EVT_GRID_LABEL_LEFT_CLICK( $self, sub {  print G2S( $_[1] ); print "click\n"; $_[1]->Skip;  });
  EVT_GRID_LABEL_LEFT_DCLICK( $self, \&show_dialog_local);

                    
 sub G2S {
  my $event = shift;
  my( $x, $y ) = ( $event->GetCol, $event->GetRow );
   @currentDataRow = getCurrent($y);
  return "( $x, $y )";
}

sub OnClose {
    my($this, $event) = @_;
     print " onclose\n ";
    $this->Destroy();
}
	
sub OnQuit {
    my $this = shift;
    
         WxAddChg->CloseWin();
         WxDelete->CloseWin();
         WxSearch->CloseWin();	
 #        WxNotes->CloseWin();
 #        WxStats->CloseWin();
   
 #       $this->Destroy();
    print " ----------\n";
    $self->Close( 1 );
    print "...........\n";
    $self->Destroy();
}

sub Importer
{
	$g_data_get = ZohoImport->ImportNewData($g_cnt_row2);
	Refresh();
}


sub tab_select
{
	
	$g_page = $g_self->{notebook_1}->GetSelection();
#	my $page = Wx::Notebook->GetSelection();
	print "page: $g_page\n";

=begin mess
#	if ((!$g_data_set)&&($g_data_get))
#	{
#		ZohoImport->get_data($g_self);
#		$g_data_set =1;
#	}
=cut

}


sub show_dialog_local
{
	my $type;
	if ($g_page == 0) 
	{
		$type = 0;
		   show_dialog($type,  @currentDataRow);
	} 
	else
	{
		if ($g_page == 1)
		{
			$type = 2;
			   show_dialog($type,  @currentDataRow);
		}
		else
		{
		    if ($g_page == 2)
		    {
		    	   $type = 3;
		    	   Delete();
		    }
		}
	}
#   show_dialog($type, @currentDataRow);
   Refresh();	
}       

#    sql set routines

sub initsql
{
          $g_table = "LeadData";
          $g_sqlcount =    "SELECT COUNT(*)  FROM LeadData where LeadID > 0";
          $g_sqlselect ="SELECT " . $tmpe . " FROM LeadData where LeadID > 0";
}

sub name_search_sql
{
	    	my  $search_crit = shift;
          $g_table = "LeadDataAll";
          $g_sqlcount =    "SELECT COUNT(*)  FROM LeadData where Lead_LastName = '$search_crit'";
          $g_sqlselect ="SELECT " . $tmpe . " FROM LeadData where Lead_LastName = '$search_crit'";
 }

 sub type_search_sql
{
	my  $search_crit = shift;
        $g_sqlcount =  " SELECT COUNT(*)  FROM LeadData where Sales_Status  = '$search_crit'";
        $g_sqlselect =   "SELECT " . $tmpe . " FROM LeadData where Sales_Status  = '$search_crit'";
}
      
sub date_search_both
{
		my  $search_crit = shift;
		my  $s1  = substr(  $search_crit, 0, 8);
		my  $s2  = substr( $search_crit, 8, 8); 
        $g_sqlcount =  " SELECT COUNT(*)  FROM LeadData where (Lead_ReferalDate  < '$s1' and Lead_ReferalDate  > '$s2')";
        $g_sqlselect =   "SELECT " . $tmpe . " FROM LeadData where (Lead_ReferalDate  <  '$s1' and Lead_ReferalDate  >  '$s2')";
}      

sub  date_search_after
{
		my  $search_crit = shift;
        $g_sqlcount =  " SELECT COUNT(*)  FROM LeadData where Lead_ReferalDate  > '$search_crit'";
        $g_sqlselect =   "SELECT " . $tmpe . " FROM LeadData where Lead_ReferalDate  > '$search_crit'";
}
      
sub date_search_before
{
			my  $search_crit = shift;
        $g_sqlcount =  " SELECT COUNT(*)  FROM LeadData where Lead_ReferalDate  < '$search_crit'";
        $g_sqlselect =   "SELECT " . $tmpe . " FROM LeadData where Lead_ReferalDate  < '$search_crit'";
}      
      
 sub state_search_sql
{
	my  $search_crit = shift;
	print " state search ---> $search_crit\n";
        $g_sqlcount =  " SELECT COUNT(*)  FROM LeadData where Lead_State = '$search_crit'";
        $g_sqlselect =   "SELECT " . $tmpe . " FROM LeadData where Lead_State = '$search_crit'";
 }
      
 
 sub Stats
{
    show_stats(@currentDataRow);
}

 
sub Notes
{
    setNote(@currentDataRow);
}
 
sub Delete
{
	print "Del: $currentDataRow[0] \n"; 
       show_delete(@currentDataRow);         
       Refresh();            
}

sub Search
{
	my $local = $currentData;
	print "Search: $local \n"; 
       my($type,$crit) = show_search();
       print "crit: $crit \n";
       print "type: $type\n";
       setsql($type,$crit);   
       Search_Refresh();                     
}     

sub setsql
{
       my ($type,$search_crit) = @_;

         print "setsql- type: $type - crit: $search_crit\n";




                               if ($type == 1)
                               {  
                               	        state_search_sql($search_crit);
                               }     
                               else
                               {
                               	         if ($type == 2)
                                        {  
                                        	 name_search_sql($search_crit);
                                        }     
                                       else
                                        {
                                        	if ($type == 3)
                                                {  
                                                	type_search_sql($search_crit);
                                                }     
                                                else
                                                {
                                                	if ($type ==4)
                                                	{
                                                		date_search_both($search_crit);
                                                	}
                                                	else
                                                	{
                                                		if ($type == 5)
                                                		{
                                                			date_search_before($search_crit);
                                                		}
                                                		else
                                                		{
                                                			if ($type == 6)
                                                			{
                                                				date_search_after($search_crit);
                                                			}
                                                		}
                                                	}
                                                }
                                         }	                
                               }
}
 
sub Search_Refresh
{
	
	print "g_select: $g_sqlselect\n";
	$g_cnt_row1 = 0;
	$g_cnt_row2 = 0;
	$g_cnt_row3 = 0;
	
	my $sqlselect = $g_sqlselect;
	
    my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});

    my ($count) = $dbh->selectrow_array($g_sqlcount);
 
    print  "cnt: $count\n";

	$g_self->SetTitle("Zoho App-");
#	$g_self->{grid_1}->Destroy();
	        $g_self->{grid_1}->ClearGrid();
	print "after destroy\n";
	
  #      $g_self->{grid_1} = Wx::Grid->new($g_self, -1);
	$g_self->{grid_1}->CreateGrid($count, 6);
	$g_self->{grid_1}->SetSelectionMode(wxGridSelectRows);
		SetHeading();
       $g_self->__set_properties();
#	$g_self->__do_layout();



   my $sth = $dbh->prepare($sqlselect);
    $sth->execute();

    my $cnt_row = 0;
    my $cnt_col = 0;
    my $l1 = 0;
    	     my $l2 = 0;
    	     my $l3 = 0;
    	     my $l4 = 0;
    	     my $l5 = 0;
    	     my $l6 = 0;
    	     
    while (my @result = $sth->fetchrow_array()) {
            print ". ";
            
            $l1 = length($result[2]);
    	    $l2 = length($result[3]);
    	    $l3 = length($result[4]);
    	    $l4 = length($result[8]);
    	    $l5 = length($result[10]);
    	    $l6 = length($result[11]);
    	
    	     
    	
    	     
             $result[2] = "_" unless ( $l1 > 0 );
             $result[3] = "_" unless ( $l2 > 0 );
             $result[4] = "_" unless ( $l3 > 0 );
             $result[8] = "_" unless ( $l4 > 0 );
             $result[10] = "_" unless ( $l5 > 0 );
             $result[11] = "_" unless ( $l6 > 0 );
 
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 0, $result[2] );
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 1, $result[3] );
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 2, $result[4] );
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 3, $result[10] );
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 4, $result[11] );
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 5, $result[8] );
           push ( @g_grid_id_array1, $result[0] );
            $g_cnt_row1++;
   	
    }
    
    print "\n";
    
    $sth->finish;
 	
	
       
 $dbh->disconnect;
	
}     
  
sub Init
{

    print "Init....\n";


    initsql();


    my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});



    my ($count) = $dbh->selectrow_array($g_sqlcount);


	$g_self->SetTitle("Zoho App");

	$g_self->{grid_1}->CreateGrid($count, 6);
	$g_self->{grid_1}->SetSelectionMode(wxGridSelectRows);
		SetHeading();
		

   my $sth = $dbh->prepare($g_sqlselect);

    $sth->execute();

    $g_cnt_row1 = 0;
    $g_cnt_row2 = 0;
    $g_cnt_row3 = 0;
    my $cnt_col = 0;
            
             my $l1 = 0;
    	     my $l2 = 0;
    	     my $l3 = 0;
    	     my $l4 = 0;
    	     my $l5 = 0;
    	     my $l6 = 0;

    while (my @result = $sth->fetchrow_array()) {
    	
    	
    	
    	     $l1 = length($result[2]);
    	     $l2 = length($result[3]);
    	     $l3 = length($result[4]);
    	     $l4 = length($result[8]);
    	     $l5 = length($result[10]);
    	     $l6 = length($result[11]);
    	
    	     
    	
    	     
             $result[2] = "_" unless ( $l1 > 0 );
             $result[3] = "_" unless ( $l2 > 0 );
             $result[4] = "_" unless ( $l3 > 0 );
             $result[8] = "_" unless ( $l4 > 0 );
             $result[10] = "_" unless ( $l5 > 0 );
             $result[11] = "_" unless ( $l6 > 0 );
 
            
    if ($result[23] eq "-")
    {        
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 0, $result[2] );
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 1, $result[3] );
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 2, $result[4] );
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 3, $result[10] );
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 4, $result[11] );
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 5, $result[8] );
           push ( @g_grid_id_array1, $result[0] );
            $g_cnt_row1++;
     }
            else
     {     
              if( $result[23] eq "Imp")
              {
              	            $g_self->{grid_2}->SetCellValue($g_cnt_row2, 0, $result[2] );
                            $g_self->{grid_2}->SetCellValue($g_cnt_row2, 1, $result[3] );
                            $g_self->{grid_2}->SetCellValue($g_cnt_row2, 2, $result[4] );
                            $g_self->{grid_2}->SetCellValue($g_cnt_row2, 3, $result[10] );
                            $g_self->{grid_2}->SetCellValue($g_cnt_row2, 4, $result[11] );
                            $g_self->{grid_2}->SetCellValue($g_cnt_row2, 5, $result[8] );
                            push ( @g_grid_id_array2, $result[0] );
                            $g_cnt_row2++;
              }
              else
              {
              	       if( $result[23] eq "Exp")
                       {
              	            $g_self->{grid_3}->SetCellValue($g_cnt_row3, 0, $result[2] );
                            $g_self->{grid_3}->SetCellValue($g_cnt_row3, 1, $result[3] );
                            $g_self->{grid_3}->SetCellValue($g_cnt_row3, 2, $result[4] );
                            $g_self->{grid_3}->SetCellValue($g_cnt_row3, 3, $result[10] );
                            $g_self->{grid_3}->SetCellValue($g_cnt_row3, 4, $result[11] );
                            $g_self->{grid_3}->SetCellValue($g_cnt_row3, 5, $result[8] );
                            push ( @g_grid_id_array3, $result[0] );
                            $g_cnt_row3++;
                     }

              }
    	}
#        print "id: $result[0], lname: $result[1], fname: $result[2], email: $result[3], password: $result[4]\n";
    }
    $sth->finish;
 	
	
#        $self->{grid_1}->SetCellValue(0, 0, "wxGrid is Good");
        
 $dbh->disconnect;
	       
}       

sub add_dialog
{
	    my @darray;
	    my $id = -99;
	    my $i = 0;
	    
     while ( $i < 5 )
     {	
	$darray[$i] = "." ;
	$i++; 
     }	
	my $tmp = join (".",@darray);
	$currentData = $id . " " . $tmp;
        show_dialog(1);
}       
       
sub getCurrent
{
	my ($index) = @_;
	my $id; 
	if ($g_page == 0)
	{
	      $id = $g_grid_id_array1[$index];
	}
	else
	{
			if ($g_page == 1)
	                {
	                       $id = $g_grid_id_array2[$index];
	                 }
	                 else
	                 {
	                 	$id = $g_grid_id_array3[$index];
	                 }

	}
	print "id: $id\n";
	
	
        my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});
	
	                   
	my @dbColumsT =     qw(LeadID 
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
	
	my $temper = join(",",@dbColumsT);
	my $sql = "SELECT " . $temper . " FROM LeadData WHERE LeadID=?";
        
        my @row = $dbh->selectrow_array($sql,undef,$id);
                 unless (@row) { die "record not found in database"; }
   # debug        my ($fname,$lname) = @row;
	
     $dbh->disconnect;
    my $i = 0;
#    my @darray;
if(0)
{
     while ( $i < 23 )
     {	
	$row[$i] = "." unless ( length($row[$i]) > 0 );
	$i++; 
     }
 }    	
	my $tmp = join (" ",@row);
	
	print " in GetCurrent - value tmp = $tmp \n ";
	
	return  @row;
}       
       
sub SetHeading
{
#           $self->{grid_1}->SetColLabelValue(0, "ID" );	
           $g_self->{grid_1}->SetColLabelValue(0, "First Name" );	
           $g_self->{grid_1}->SetColLabelValue(1, "Last Name" );	
           $g_self->{grid_1}->SetColLabelValue(2, "Phone" );	
           $g_self->{grid_1}->SetColLabelValue(3, "City" );
            $g_self->{grid_1}->SetColLabelValue(4, "State" );
            $g_self->{grid_1}->SetColLabelValue(5, "Date" );	
}	
       
sub Refresh
{
	print "Refresh\n";
	
	    initsql();
	
    my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", {});

    my ($count) = $dbh->selectrow_array($g_sqlcount);
      
      $g_refresh = 1;
        
	$g_self->SetTitle("Zoho App*");
	
	$g_cnt_row1 = 0;
	$g_cnt_row2 = 0;
	$g_cnt_row3 = 0;
	
	# How many Cols/Rows
#my $Cols = $g_self->{grid_1}->GetNumbersCols();
#my $Rows = $g_self->{grid_1}->GetNumbersRows();

# Delete all Cols/Rows
#$g_self->{grid_1}->DeleteCols(0,$count,1);
#$g_self->{grid_1}->DeleteRows(0,6,1);
	
	
        $g_self->{grid_1}->ClearGrid();
        $g_self->{grid_2}->ClearGrid();
        $g_self->{grid_3}->ClearGrid();
        
            @g_grid_id_array1= ();
            @g_grid_id_array2 = ();
            @g_grid_id_array3 = ();

		
#	$g_self->{grid_1}->CreateGrid($count, 6);
#	$g_self->{grid_1}->SetSelectionMode(wxGridSelectRows);

		SetHeading();
	$g_self->__set_properties();
	
#	$g_self->__do_layout2();	
		

   my $sth = $dbh->prepare($g_sqlselect);

    $sth->execute();

    my $cnt_row = 0;
    my $cnt_col = 0;
    
    while (my @result = $sth->fetchrow_array()) {
    
      if ($result[23] eq "-")
    {        
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 0, $result[2] );
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 1, $result[3] );
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 2, $result[4] );
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 3, $result[10] );
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 4, $result[11] );
            $g_self->{grid_1}->SetCellValue($g_cnt_row1, 5, $result[8] );
           push ( @g_grid_id_array1, $result[0] );
            $g_cnt_row1++;
     }
            else
     {     
              if( $result[23] eq "Imp")
              {
              	            $g_self->{grid_2}->SetCellValue($g_cnt_row2, 0, $result[2] );
                            $g_self->{grid_2}->SetCellValue($g_cnt_row2, 1, $result[3] );
                            $g_self->{grid_2}->SetCellValue($g_cnt_row2, 2, $result[4] );
                            $g_self->{grid_2}->SetCellValue($g_cnt_row2, 3, $result[10] );
                            $g_self->{grid_2}->SetCellValue($g_cnt_row2, 4, $result[11] );
                            $g_self->{grid_2}->SetCellValue($g_cnt_row2, 5, $result[8] );
                            push ( @g_grid_id_array2, $result[0] );
                            $g_cnt_row2++;
              }
              else
              {
              	       if( $result[23] eq "Exp")
                       {
              	            $g_self->{grid_3}->SetCellValue($g_cnt_row3, 0, $result[2] );
                            $g_self->{grid_3}->SetCellValue($g_cnt_row3, 1, $result[3] );
                            $g_self->{grid_3}->SetCellValue($g_cnt_row3, 2, $result[4] );
                            $g_self->{grid_3}->SetCellValue($g_cnt_row3, 3, $result[10] );
                            $g_self->{grid_3}->SetCellValue($g_cnt_row3, 4, $result[11] );
                            $g_self->{grid_3}->SetCellValue($g_cnt_row3, 5, $result[8] );
                            push ( @g_grid_id_array3, $result[0] );
                            $g_cnt_row3++;
                     }

              }
    	}
          
    
    	
#        print "id: $result[0], lname: $result[1], fname: $result[2], email: $result[3], password: $result[4]\n";
    }
    $sth->finish;
 	
	
#        $self->{grid_1}->SetCellValue(0, 0, "wxGrid is Good");
        
 $dbh->disconnect;
	
}       

# end wxGlade
}


sub __do_layout {
	my $self = shift;

# begin wxGlade: MyFrame::__do_layout

	$self->{sizer_1} = Wx::BoxSizer->new(wxVERTICAL);

	$self->{sizer_2} = Wx::BoxSizer->new(wxHORIZONTAL);
	$self->{sizer_3} = Wx::BoxSizer->new(wxHORIZONTAL);
	$self->{sizer_4} = Wx::BoxSizer->new(wxHORIZONTAL);
	
	$self->{sizer_2}->Add($self->{grid_1}, 1, wxEXPAND, 0);
	$self->{notebook_1_pane_1}->SetSizer($self->{sizer_2});

	$self->{sizer_3}->Add($self->{grid_2}, 1, wxEXPAND, 0);
	$self->{notebook_1_pane_2}->SetSizer($self->{sizer_3});

	$self->{sizer_4}->Add($self->{grid_3}, 1, wxEXPAND, 0);
	$self->{notebook_1_pane_3}->SetSizer($self->{sizer_4});



	$self->{notebook_1}->AddPage($self->{notebook_1_pane_1}, "Reg");
	$self->{notebook_1}->AddPage($self->{notebook_1_pane_2}, "Imp");
	$self->{notebook_1}->AddPage($self->{notebook_1_pane_3}, "Exp");


	$self->{sizer_1}->Add($self->{notebook_1}, 1, wxEXPAND, 0);
	$self->SetSizer($self->{sizer_1});
	$self->{sizer_1}->Fit($self);
	$self->Layout();

# end wxGlade
}


# end of class MyFrame

1;

1;

package main;

# unless(caller){
	local *Wx::App::OnInit = sub{1};
	my $app = Wx::App->new();
	Wx::InitAllImageHandlers();

	my $frame_1 = MyFrame->new();
	
#  debug	print " frame_1 = $frame_1 \n ";

	$app->SetTopWindow($frame_1);
	$frame_1->Show(1);
	$app->MainLoop();
 # }

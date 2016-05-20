#!/usr/bin/python
# -*- coding: utf-8 -*-

import gtk, os

####################################################
##		variables 
####################################################

## Lien vers le fond d'ecran
IMG_FILE = '$HOME/.scripts/panneau_da/img/panneau_da.png'

## Jouer Arctic Tale
CMD_ART = 'cvlc -f --play-and-exit "$HOME/Vidéos/Arctic Tale.avi" && $HOME/.scripts/panneau_da/panneau_da'

## Jouer Big Buck Bunny
CMD_BBB = 'cvlc -f --play-and-exit "$HOME/Vidéos/big_buck_bunny.avi" && $HOME/.scripts/panneau_da/panneau_da'

## Jouer Kung Fu Panda
CMD_KFP = 'cvlc -f --play-and-exit "$HOME/Vidéos/Kung-Fu Panda.avi" && $HOME/.scripts/panneau_da/panneau_da'

## Jouer La citadelle assiégée
CMD_LCA = 'cvlc -f --play-and-exit "$HOME/Vidéos/La Citadelle Assiegee.avi" && $HOME/.scripts/panneau_da/panneau_da'

## Jouer Raiponce
CMD_RAI = 'cvlc -f --play-and-exit "$HOME/Vidéos/Raiponce.avi" && $HOME/.scripts/panneau_da/panneau_da'

## Jouer Rio
CMD_RIO = 'cvlc -f --play-and-exit "$HOME/Vidéos/Rio.avi" && $HOME/.scripts/panneau_da/panneau_da'

## Jouer Wall-e
CMD_WAL = 'cvlc -f --play-and-exit "$HOME/Vidéos/Wall-E.avi" && $HOME/.scripts/panneau_da/panneau_da'

####################################################
##		debut du script 
####################################################


class MyApp():
    def __init__(self):
        
        self.window = gtk.Window()        
        self.window.set_title("panneau dessins anim")
        self.window.connect("destroy", self.doquit)
        self.window.connect("key-press-event", self.onkeypress)
        self.window.set_size_request(620,200)
        self.window.modify_bg(gtk.STATE_NORMAL, gtk.gdk.color_parse("black"))
        self.window.set_decorated(False)
        self.window.set_position(gtk.WIN_POS_CENTER)
        
        self.mainpanel = gtk.Fixed()
        self.window.add(self.mainpanel)
        
        self.screen_x , self.screen_y = gtk.gdk.screen_width(), gtk.gdk.screen_height()

        x = ( self.screen_x / 2 ) - ( 140 * 6 / 2 ) - 30
        y = ( self.screen_y / 2 ) - 105

        self.bt_tab = []
        ## 1st Line
        self.add_bouton("application-exit", x+1120, y-405, "Quitter")
        self.add_bouton("art", x+0, y+30, "Arctic Tale")
        self.add_bouton("bbb", x+150, y+30, "Big Buck Bunny")
        self.add_bouton("kfp", x+310, y+30, "Kung Fu Panda")
        self.add_bouton("lca", x+300, y+30, "La Citadelle Assiégée")
        self.add_bouton("rai", x+450, y+30, "Raiponce")
        self.add_bouton("rio", x+600, y+30, "Rio")
        self.add_bouton("wal", x+750, y+30, "Wall-E")
        
        self.set_background()
        self.bt_tab[0].grab_focus()             

    def set_background(self):
        pixbuf = gtk.gdk.pixbuf_new_from_file(IMG_FILE)
        pixbuf = pixbuf.scale_simple(gtk.gdk.screen_width(), gtk.gdk.screen_height(), gtk.gdk.INTERP_BILINEAR)
        pixmap, mask = pixbuf.render_pixmap_and_mask()
        self.window.set_app_paintable(True)
        self.window.resize(self.screen_x, self.screen_y)
        self.window.realize()
        self.window.window.set_back_pixmap(pixmap, False)
        self.window.move(0,0)
        del pixbuf
        del pixmap

    def add_bouton(self, icon, x, y, info):
        image = gtk.Image()
        image.set_from_file("img/" + icon + ".png")
        image.show()
        bouton = gtk.Button()
        bouton.set_relief(gtk.RELIEF_NONE)
        bouton.set_focus_on_click(False)
        bouton.set_border_width(0)
        #bouton.set_property('can-focus', False)
        bouton.add(image)
        tooltips = gtk.Tooltips()
        tooltips.set_tip(bouton, str(info))
        bouton.show()
        self.mainpanel.put(bouton, x,y)
        bouton.connect("clicked", self.clic_bouton, icon)
        self.bt_tab.append(bouton)

    # Cette fonction est invoquee quand on clique sur un bouton.
    def clic_bouton(self, widget, data=None):
        if (data=='art'):
            os.system(CMD_ART)

        elif (data=='bbb'):
            os.system(CMD_BBB)

        elif (data=='kfp'):
            os.system(CMD_KFP)

        elif (data=='lca'):
            os.system(CMD_LCA)

        elif (data=='rai'):
            os.system(CMD_RAI)

        elif (data=='rio'):
            os.system(CMD_RIO)

        elif (data=='wal'):
            os.system(CMD_WAL)

        self.doquit()           

    def onkeypress(self, widget=None, event=None, data=None):
        if event.keyval == gtk.keysyms.Escape:
            self.doquit() 
    
    def doquit(self, widget=None, data=None):
        gtk.main_quit()

    def run(self):
        self.window.show_all()
        gtk.main()

#-------------------------
if __name__ == "__main__":
#-------------------------
    ## need to change directory
    SRC_PATH = os.path.dirname( os.path.realpath( __file__ ) )
    os.chdir(SRC_PATH)
    app = MyApp()
    app.run()

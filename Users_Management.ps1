class Gestion_Utilisateurs_Locaux {

    [void] ListeUtilisateursLocaux() {
        Write-Host "Liste des utilisateurs locaux et leurs dernières connexions dans le système"

        $liste = Get-LocalUser | Select-Object Name, Enabled, LastLogon | Format-Table -AutoSize | Out-String
        Write-Host $liste
    }

    #######################################################################################################################

    [bool] TestExistanceUtilisateursLocaux([string] $username) {
        try {
            $user = Get-LocalUser -Name $username -ErrorAction Stop
            return $true
        } catch {
            return $false
        }
    }

    #######################################################################################################################

    [void] AjouterUtilisateurLocal([string] $username, [string] $password) {
        $usernameExiste = $this.TestExistanceUtilisateursLocaux($username)
        if (-not $usernameExiste) {
            Write-Host "Ajout de l'utilisateur local : $username"
            $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
            New-LocalUser -Name $username -Password $securePassword -FullName "Local User" -Description "Créé en PowerShell"
            Write-Host "L'utilisateur a été ajouté correctement."
        } else {
            Write-Host "L'utilisateur $username existe déjà."
        }
    }

    #######################################################################################################################

    [void] SuppressionUtilisateurLocal([string] $username) {
        $utilisateurExiste = $this.TestExistanceUtilisateursLocaux($username)
        if ($utilisateurExiste) {
            Write-Host "Suppression de l'utilisateur local : $username"
            Remove-LocalUser -Name $username -Confirm:$false
            Write-Host "L'utilisateur a été supprimé correctement."
        } else {
            Write-Host "L'utilisateur '$username' n'existe pas."
        }
    }
}

# Création de l'objet Gestion_Utilisateurs_Locaux
$gestion = [Gestion_Utilisateurs_Locaux]::new()

# Menu interactif
while ($true) {
    Write-Host "`nMenu Gestion des Utilisateurs Locaux"
    Write-Host "1. Lister les utilisateurs locaux"
    Write-Host "2. Vérifier l'existence d'un utilisateur"
    Write-Host "3. Ajouter un utilisateur local"
    Write-Host "4. Supprimer un utilisateur local"
    Write-Host "5. Quitter"
    $choix = Read-Host "Choisissez une option (1-5)"

    switch ($choix) {
        1 {
            $gestion.ListeUtilisateursLocaux()
        }
        2 {
            $username = Read-Host "Entrez le nom d'utilisateur à vérifier"
            if ($gestion.TestExistanceUtilisateursLocaux($username)) {
                Write-Host "L'utilisateur '$username' existe."
            } else {
                Write-Host "L'utilisateur '$username' n'existe pas."
            }
        }
        3 {
            $username = Read-Host "Entrez le nom d'utilisateur à ajouter"
            $password = Read-Host "Entrez le mot de passe pour $username"
            $gestion.AjouterUtilisateurLocal($username, $password)
        }
        4 {
            $username = Read-Host "Entrez le nom d'utilisateur à supprimer"
            $gestion.SuppressionUtilisateurLocal($username)
        }
        5 {
            Write-Host "Au revoir!"
            break
        }
        default {
            Write-Host "Option non valide. Veuillez choisir une option entre 1 et 5."
        }
    }
}

Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7AF646147A
	for <lists+kvm-ppc@lfdr.de>; Mon, 29 Nov 2021 13:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244747AbhK2MHf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 29 Nov 2021 07:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243112AbhK2MFf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 29 Nov 2021 07:05:35 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF44C08EE2C
        for <kvm-ppc@vger.kernel.org>; Mon, 29 Nov 2021 03:04:57 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x131so16441115pfc.12
        for <kvm-ppc@vger.kernel.org>; Mon, 29 Nov 2021 03:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=KFfRT2lRkFEqjXhqgHAkc5Xn/fCyNiJ1cySM/29/zvo=;
        b=Yz5NXtbkDx2lEw7t+SOSCF3N7Khn4AGIiDr3cZyZYC49OlNtJmUWu5fRS1iFkeBBPe
         L0HXaM5mpYslDrMBaXolmFwi+F1tMHmsiyGzZ3nkXvfviEKT0OouvOqOcIEkmOw4Mogq
         DT4Ob7z6PcqMHUKQbPzOduMumKmk19QA9Eeqon7wwyoILvtbUF0U0Dxb9LHPzLtiIb5C
         racOAaLWVomeahjc0sJI0z4Ja2wLKQ1buzqpxT2iWu5uJKs4aowy/5ahKgrhDpzxtxwD
         YQ1ahArD3YeSDZUHQGzEWrRBg2VLg45FrJ880vfqOO+7frdMEqTIxcN8f/Sy7fHmtWnT
         LVvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=KFfRT2lRkFEqjXhqgHAkc5Xn/fCyNiJ1cySM/29/zvo=;
        b=faE0mgcPiR7+S2ukAnn739lpLCaLSdYcW3CmiFdevjik7qIv4+cXjUbKC54pbmVSxj
         NenZ8bZ6q9XhyiWanMrPbpGMA2W3sMBSmsh54w7U+1F5VSc3/SmI+Cb7z7FcYymQIlZC
         XqTqee9F/bne1WzpI6NmPsGxDxQosoe5g4D73wso7sa1XoCSlrWYkfFcAJ11n71hKNxT
         XJDJkLpO4J8/Ltl8hiAwEGBMbdkDUYs4g4awoxL1hokQg+8FRoKX/7CpKfOSjvQg7D2A
         /tUxf1AO9VY35FaHTeeXKUZFTGuqVqXWDoLBrDdROzTinUMrXnnv47bNGeH0KL7iAuKm
         oZVw==
X-Gm-Message-State: AOAM5336Wssxsa7clYQatOq0YR2cJEwArEipXu24GfQ1zTyG4aeMzOKS
        /Ga/Z6S7uOF/vOChlroGn+0k1YuRTAqAlyIW1g==
X-Google-Smtp-Source: ABdhPJz2Y30Hka1PFo7QeJP48wRUpDllXWUXqFLzBWbx70f1mOKPsOPtp0AevwlrZzf/sIEJjx0T1NVf30wsWGd/IXg=
X-Received: by 2002:a05:6a00:a8b:b0:44d:ef7c:94b9 with SMTP id
 b11-20020a056a000a8b00b0044def7c94b9mr38582775pfl.36.1638183896534; Mon, 29
 Nov 2021 03:04:56 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:522:16c9:b0:3db:6e05:78bb with HTTP; Mon, 29 Nov 2021
 03:04:55 -0800 (PST)
Reply-To: bintou_deme2011@aol.com
From:   Bintou Deme <jindaratdaosornprasat20147@gmail.com>
Date:   Mon, 29 Nov 2021 11:04:55 +0000
Message-ID: <CAJY0BCnF-EXhMWZJ4Crowov1rROegH4dn5TwBAZL-DFO4W17Sw@mail.gmail.com>
Subject: Von Bintou
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Von: Bintou Deme
Liebste,
Guten Tag und vielen Dank f=C3=BCr Ihre Aufmerksamkeit. Bitte, ich m=C3=B6c=
hte,
dass Sie meine E-Mail sorgf=C3=A4ltig lesen und mir helfen, dieses Projekt
zu bearbeiten. Ich bin Miss Bintou Deme und m=C3=B6chte Sie in aller
Bescheidenheit um Ihre Partnerschaft und Unterst=C3=BCtzung bei der
=C3=9Cbertragung und Anlage meiner Erbschaftsgelder in H=C3=B6he von
6.500.000,00 US-Dollar (sechs Millionen f=C3=BCnfhunderttausend US-Dollar)
bitten, die mein verstorbener geliebter Vater vor seinem Tod bei einer
Bank hinterlegt hat.

Ich m=C3=B6chte Ihnen versichern, dass dieser Fonds legal von meinem
verstorbenen Vater erworben wurde und keinen kriminellen Hintergrund
hat. Mein Vater hat diesen Fonds legal durch ein legitimes Gesch=C3=A4ft
erworben, bevor er w=C3=A4hrend seiner Gesch=C3=A4ftsreise zu Tode vergifte=
t
wurde. Der Tod meines Vaters wurde von seinen Verwandten, die ihn
w=C3=A4hrend seiner Dienstreise begleiteten, vermutet. Denn nach 3 Monaten
nach dem Tod meines Vaters begannen Seine Verwandten, alle Besitzt=C3=BCmer
meines verstorbenen Vaters zu beanspruchen und zu verkaufen.

Die Verwandten meines verstorbenen Vaters wissen nichts von den
6.500.000,00 US-Dollar (sechs Millionen f=C3=BCnfhunderttausend US-Dollar),
die mein verstorbener Vater auf die Bank eingezahlt hat und mein
verstorbener Vater sagte mir heimlich, bevor er starb, dass ich in
jedem Land nach einem ausl=C3=A4ndischen Partner suchen sollte meiner Wahl,
wohin ich diese Gelder f=C3=BCr meine eigenen Zwecke =C3=BCberweise.

Bitte helfen Sie mir, dieses Geld f=C3=BCr gesch=C3=A4ftliche Zwecke in Ihr=
em
Land auf Ihr Konto zu =C3=BCberweisen. Ich habe diese Entscheidung
getroffen, weil ich viele Dem=C3=BCtigungen von den Verwandten meines
verstorbenen Vaters erlitten habe. Zur Zeit habe ich Kommunikation mit
dem Direktor der Bank, bei der mein verstorbener Vater dieses Geld
hinterlegt hat. Ich habe dem Direktor der Bank die Dringlichkeit
erkl=C3=A4rt, sicherzustellen, dass das Geld ins Ausland =C3=BCberwiesen wi=
rd,
damit ich dieses Land zu meiner Sicherheit verlassen kann. Der
Direktor der Bank hat mir zugesichert, dass das Geld =C3=BCberwiesen wird,
sobald ich jemanden vorlege, der den Geldbetrag in meinem Namen f=C3=BCr
diesen Zweck ehrlich entgegennimmt.

Seien Sie versichert, dass die Bank den Betrag auf Ihr Konto =C3=BCberweist
und es keine Probleme geben wird. Diese Transaktion ist 100%
risikofrei und legitim. Ich bin bereit, Ihnen nach erfolgreicher
=C3=9Cberweisung dieses Geldes auf Ihr Konto 30% der Gesamtsumme als
Entsch=C3=A4digung f=C3=BCr Ihren Aufwand anzubieten. Sie werden mir auch
helfen, 10% an Wohlt=C3=A4tigkeitsorganisationen und Heime f=C3=BCr mutterl=
ose
Babys in Ihrem Land zu spenden.

Bitte alles, was ich m=C3=B6chte, ist, dass Sie f=C3=BCr mich als mein
ausl=C3=A4ndischer Partner auftreten, damit die Bank dieses Geld auf Ihr
Konto =C3=BCberweist, damit ich in diesem Land leben kann. Bitte, ich
brauche Ihre dringende Hilfe wegen meines jetzigen Zustands. Mit Ihrer
vollen Zustimmung, mit mir zu diesem Zweck zusammenzuarbeiten,
bekunden Sie bitte Ihr Interesse, indem Sie mir antworten, damit ich
Ihnen die notwendigen Informationen und die Details zum weiteren
Vorgehen geben kann. Ich werde Ihnen 30% des Geldes f=C3=BCr Ihre Hilfe
anbieten und Hilfestellung, damit umzugehen.

Ihre dringende Antwort wird gesch=C3=A4tzt.
Mit freundlichen Gr=C3=BC=C3=9Fen
Bintou Deme

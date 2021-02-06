Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3404311DCB
	for <lists+kvm-ppc@lfdr.de>; Sat,  6 Feb 2021 15:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhBFOjL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 6 Feb 2021 09:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhBFOjH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 6 Feb 2021 09:39:07 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B7AC061797
        for <kvm-ppc@vger.kernel.org>; Sat,  6 Feb 2021 06:38:27 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id k25so10740289oik.13
        for <kvm-ppc@vger.kernel.org>; Sat, 06 Feb 2021 06:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=sY4fgq/DSyThalwU7QX+pWYKs/8sGH7ZznMUn5qQ1EY=;
        b=KCfLZjvhFgHesWSEZk6H0GvDOPkz+hiz1wrxz+2sjTnLA31v+29yLO+DcIkBHXUojg
         BBW+pUPpX8Ee5dXRLJnsCy9HuGTR3nWrTpfZ2PUMKswaT1BqIFJpjI45EPk+Wp3V4oee
         UEAkkbhEDbLUfa2YMngXw0gzKAfZeqgxcbqKJ7UuntXiG+f8qcDjjgnlkmj/dLH295m7
         wZG1LRGPRu8tkjZGMBLFXfmYJWfRiEobWc+g8bepYnGStiq19OUlxE85iBWxgDmhTA7J
         ZQlXSMQWEOf42r/eAlAjSRlaPRtWFmFuEyOpnh987Zd+6zGpOYnJ27KIx63Rwrs3eHin
         uv1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=sY4fgq/DSyThalwU7QX+pWYKs/8sGH7ZznMUn5qQ1EY=;
        b=mpqhaGKtgurDgLVcEo+O6hDvJHoGbjmd9Up1kdHBJKfElCgntkGBblIMwCfTZDLSKc
         490RZYQanzPqGjonPQLr2ltfOuONVBGhgFrqzmUNCXUI8ZH5ntcmb5+AsjvmL4UhpvxP
         6/AKUX7AcVSwf93TaAQqIqSuTdPMlbHoNs5VpZ/cZmEr+tNfRCL7NcuCPpkJNnly4mKb
         6ZpasQzPuNAYBpMk0UTS6MTtfVOp7qxqcx+p5sKmy6ZsHQDrRUxHgC2Hm8ND51BAu3LE
         6RLZXOghg3zZdtn7kIle8McmeX8o6J6V2Aa1Bh9gG3qLqXdBkK6ZCmtU8cZ/qjkFDOlN
         oxXg==
X-Gm-Message-State: AOAM531LT40ToRtxYxzAI/xUtlmS7+cK3W8tlu45Q3lRws+rxB4dXjmq
        uz6gNg0J88lXs/ALPTpqOenec2Rp0n0uiOgz54s=
X-Google-Smtp-Source: ABdhPJwT2tSEwBkmhksjQK4hNG864XaadhTQ4YwTUtB6htHhH1WwHQtpBtELAkxxjWnUPlHvg3qLIYzuzQlXgBm/SBY=
X-Received: by 2002:aca:a844:: with SMTP id r65mr6005813oie.35.1612622307358;
 Sat, 06 Feb 2021 06:38:27 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:3e4c:0:0:0:0:0 with HTTP; Sat, 6 Feb 2021 06:38:27 -0800 (PST)
Reply-To: lawyer.nba@gmail.com
From:   Barrister Daven Bango <stephennbada@gmail.com>
Date:   Sat, 6 Feb 2021 15:38:27 +0100
Message-ID: <CAO_fDi9EeY5H=i8goB4Rpk+zW34nfvqFhOxm-DaQz5ptc4fBuA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

--=20
Korisnik fonda =C4=8Destitanja, Va=C5=A1a sredstva za naknadu od 850.000,00
ameri=C4=8Dkih dolara odobrila je Me=C4=91unarodna monetarna organizacija (=
MMF)
u suradnji s (FBI) nakon mnogo istraga. =C4=8Cekamo da se obratimo za
dodatne informacije

Advokat: Daven Bango
Telefon: +22891667276
(URED MMF-a LOME TOGO)

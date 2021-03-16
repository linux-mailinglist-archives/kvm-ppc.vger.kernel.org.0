Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A176733CDBC
	for <lists+kvm-ppc@lfdr.de>; Tue, 16 Mar 2021 07:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhCPGGc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 16 Mar 2021 02:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbhCPGGP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 16 Mar 2021 02:06:15 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABE3C06174A
        for <kvm-ppc@vger.kernel.org>; Mon, 15 Mar 2021 23:06:15 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id o10so4241736plg.11
        for <kvm-ppc@vger.kernel.org>; Mon, 15 Mar 2021 23:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=m1wUWomo4Lxo1+B3lTnU+y6F4eEY7QF7tsY8tQgurkc=;
        b=pRB9Cjv+FXdYmgP7PrCMggiPZjmv+Oqy3brJjW4dq60pXhkVijaJdztW6s46j7cFyn
         xgMOIWdMxYwj7/Lkj8HTTRVP1gKuRq4+lZZd5PFAgMLPRk2U99K+fT/NPIf9BCZawyjj
         ghTXMdiohzyY/IO0ZJqmJ/d4z9Tva4tFR+1DLO7ze28c6603uSXsceW0zD47YAU9Hljf
         yOKfTqcZolL+mq382+LdP3noiSGBsgenL0G1ikUFvzhUmi3DvJ9eXdT9fUNqTKI/s7X/
         VvrgMxTYVAmH0LV0QtGq5k9Hi7PmJbD4hv34SXRGoTM6PHspwPj2ayPkStCQ5I8wlDUZ
         UWHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=m1wUWomo4Lxo1+B3lTnU+y6F4eEY7QF7tsY8tQgurkc=;
        b=eBJl2HgxiYmeU4PEv/xW9uZkNq3YQLazrDKPUCJ3BNKA8oIx9UwtqO39H3ZINnq5wn
         QtgaE4lvahIvnXdgRJJwMtPgpUexxQCnRgDZUu1S+v19ZVmC7Be04URPhtk4uZm4Be48
         0EFcckkhYwskqXpKAg5V2smb7MIsK++GnRfRROQTL7DAIlHhSBU1Ic3qDkLryi0OaSuk
         V6Y6+4tEfzCbNA/NvFkjeEPYrh8iDzj6EbAbCeZkhu/wY6Fg7JU+Ojh3C5b/3Owyq6XK
         8OA3yHdFvB1tG/a8AfED/IbrgHG1ETaeS4ljHKaCj+S5naTl4eGoSf2vGEv7TUx7wLta
         N6ew==
X-Gm-Message-State: AOAM531R7w/Kc6qol4xPKMVWNJTvWLyXlLIlIFIUHbNx0gbGMQzUOOkn
        j4Z24EGibTXJ/4vmq7TJ7HsuwCVKG3U=
X-Google-Smtp-Source: ABdhPJz38WZUQ78MyF/vnIvl8Pfyf8K0gq4+2+c19NlbQNWJ6jUKkqkhOWUmutOgmfjvqVdh44P1Vw==
X-Received: by 2002:a17:902:e889:b029:e6:4c9:ef02 with SMTP id w9-20020a170902e889b02900e604c9ef02mr15075443plg.1.1615874774318;
        Mon, 15 Mar 2021 23:06:14 -0700 (PDT)
Received: from localhost (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a21sm15251260pfh.31.2021.03.15.23.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 23:06:13 -0700 (PDT)
Date:   Tue, 16 Mar 2021 16:06:08 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 00/41] KVM: PPC: Book3S: C-ify the P9 entry/exit code
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Message-Id: <1615874475.4bnxc193mb.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nicholas Piggin's message of March 6, 2021 1:05 am:
> This tidies up things, and fixes a few corner cases and unfinished
> "XXX:" bits. The major one being "bad host interrupt" detection and
> handling (taking a MCE/SRESET while switching into guest regs) which
> was missing previously from the new P9 path.
>=20
> Adds a few new patches and makes some changes for issues noticed
> by reviewers (thank you).

I've put a tree up here with latest changes.

https://github.com/npiggin/linux/tree/kvm-in-c

Should include all the review comments from this thread so far, no
other major changes.

I'll hold off posting out another series probably at least until
powerpc next solidifies a bit more (some of the interrupt handler
changes pending there might clash).

Thanks,
Nick

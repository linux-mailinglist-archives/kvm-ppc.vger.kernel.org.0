Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BB62CA36A
	for <lists+kvm-ppc@lfdr.de>; Tue,  1 Dec 2020 14:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgLANDG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 1 Dec 2020 08:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgLANDF (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 1 Dec 2020 08:03:05 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2EAC0613CF
        for <kvm-ppc@vger.kernel.org>; Tue,  1 Dec 2020 05:02:20 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id p5so1562964iln.8
        for <kvm-ppc@vger.kernel.org>; Tue, 01 Dec 2020 05:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GujISGwhlbmPBHTK++whZ1M7hVGM+4rvkVOJDvu+Tpw=;
        b=ZbPk4tHwP3WguKetrkTHklUy3UcrKSyWgK6Uym2IZE3wBAOwdVH5c/IDdmwjZPuuqm
         3fBZ1XS0IiiaE//0AYRql3RFisscyQgiDg3DEC725uSg82KNi8qLfcIY1mvrrp0em8t0
         cxqPnFLueiusSfO/++oRYAXbjidQLywBD922gkvVqYDTx9GKI06POfQJ55if1kit6p9l
         cg0MpVzrpdbtvktESIAkHgYo8wSaE+CQbZcaXpPVaoXZGPd0UtmUXya+z7CZOP0Jcy7S
         /Gr2+bDlQj6GL3O6CRxPAO5tEP7e/pd5kFNcYys5eFtWBBHnhM55CGW1MYspSPy7xfnQ
         RBKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GujISGwhlbmPBHTK++whZ1M7hVGM+4rvkVOJDvu+Tpw=;
        b=HoxKlPnbieusLzZ/eTcvoo+LoE/GFaOdoax6g4jy34l2GYnUMtObWuw7925hab7IAr
         UDQ8O0K0j3DVLm5Wq9WqA4Cz0DponG3ZIx3QUq+6YYRcIDC3GYNMXjRJCH4E1JJVQ/50
         ArBVMpVSiQtu6TP4ihy8UH+JHLDs3MXQ7o7ac9n2UWiwWuHZbQ81aoH08ubAIStkFDI9
         GCNih3FIEXeq//aASeeGCDv0Rhw+0wgMirRqXvr/aWVNwU/nfvSBd1X8hdZuIC2v8lTu
         J393pgIPFPJPOaLcli3ktUNGCOIPfPRMLAiJALTZn6z19QwOAqU229U7ZVJQSio8c9VI
         oRoA==
X-Gm-Message-State: AOAM530hU5ifDKi2tFPvMAguhCE7KT68QgK/dMh1ZWU8qO6PD3dQwjyP
        +enWlWpbJS44oKhXpjXFHAMD4sSX4+k+INn5nf0=
X-Google-Smtp-Source: ABdhPJxpbyyKEZVcWXZZ5bWcz5/0zeLgENsm2YN9RmeGEPYwjqWjjZ85QRhCQWvD9e7ZGl2BamxNDQpt1lIwTNgMtII=
X-Received: by 2002:a92:d40d:: with SMTP id q13mr2324683ilm.253.1606827739426;
 Tue, 01 Dec 2020 05:02:19 -0800 (PST)
MIME-Version: 1.0
References: <160682501436.2579014.14501834468510806255.stgit@lep8c.aus.stglabs.ibm.com>
 <CAM9Jb+iPV470063QYq145znYW8CmqjNgdL=q6=3JXUJJt+z5gw@mail.gmail.com> <20035bbc-a1e0-82fd-105d-999e1afff029@linux.ibm.com>
In-Reply-To: <20035bbc-a1e0-82fd-105d-999e1afff029@linux.ibm.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Tue, 1 Dec 2020 14:02:08 +0100
Message-ID: <CAM9Jb+gS6z603kLwgB62zrHNpLOqW6FAEtDcbwiG5mGRzvZUVg@mail.gmail.com>
Subject: Re: [RFC PATCH] powerpc/papr_scm: Implement scm async flush
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc:     Shivaprasad G Bhat <sbhat@linux.ibm.com>, ellerman@au1.ibm.com,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

> >> Tha patch implements SCM async-flush hcall and sets the
> >> ND_REGION_ASYNC capability when the platform device tree
> >> has "ibm,async-flush-required" set.
> >
> > So, you are reusing the existing ND_REGION_ASYNC flag for the
> > hypercall based async flush with device tree discovery?
> >
> > Out of curiosity, does virtio based flush work in ppc? Was just thinking
> > if we can reuse virtio based flush present in virtio-pmem? Or anything
> > else we are trying to achieve here?
> >
>
>
> Not with PAPR based pmem driver papr_scm.ko. The devices there are
> considered platform device and we use hypercalls to configure the
> device. On similar fashion we are now using hypercall to flush the host
> based caches.

o.k. Thanks for answering.

Best regards,
Pankaj

>
> -aneesh

Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407541B2843
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Apr 2020 15:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgDUNoJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Apr 2020 09:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728865AbgDUNoI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Apr 2020 09:44:08 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E183C061A10;
        Tue, 21 Apr 2020 06:44:08 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k6so404443iob.3;
        Tue, 21 Apr 2020 06:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sPfBvq/n3vTz/kJ2DUkeMcpcV+Na4dhwXrNFcf9zH4c=;
        b=fQyXbJZ4IBEWkP/bdhtRwYUJUyQ0QJnF1Bb8f3of8yxd8ucr8UU+FTlvyoiYxIWzxo
         NQKQCkVQWRv76mDcDKhDZEfFfi6kYNzbPwa4HgPt8JvMoUxE3KpSFqDrZvK41gKybpJG
         zaxKqxrkiLVmaK+94om70VgXPxkKyqWCnPqxEtgyaL1RLXcWyvmWw7wfVRqQmjdS43er
         iMxuXXrsCwoFS6hAlymsfQfTCsXbO0HMd7M6M6CNNyk7t/Kjk2cOCszE7sfqEjBSZXW1
         g1m21BNDn5VbS1z2vfpxWNC63rg7k/IjjF4j680C9GslztsSyKI7MOeXuHNz3AjuXc5r
         I89Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sPfBvq/n3vTz/kJ2DUkeMcpcV+Na4dhwXrNFcf9zH4c=;
        b=JtErP1bjzSuaWY+q4QTZyXerekqyJ2Ln8/kDFCTtOIcOc5Si4WKxPVlvTpFmmZT48P
         jPsOycABMCm/cJYrP00jmSfi0YfDwXfBzDW+3IjyKgU9yyXLDu3smISMAdgjFNoQFJpU
         D65J5mnicZ5ryOePAYFZHfWMKzQNv5o/V/LQB1IeQIiiwmCqFiETTA/nhZAqcGJfgkDb
         u/3vuoa5uTbBfz9tFrm8BqLjSi234i3JXdavNpdwnaAlo536B/22QDZkvt24NmxSIj0h
         mfaQnkzadGH+rs/1/NV1e8qP8xX7MFyNQNflM9PPkvyr36OfpjL/rpYnNx1UCvMB6i3Y
         DYlw==
X-Gm-Message-State: AGi0Puai63P1uw6ezGxz7WZlBMNGT+Vn4rtqfHXopF2NMWYH9AHGKcoC
        hvdCjDgb/yU6CMtPbl2C4WP5bhhFH+yimj3O4p8=
X-Google-Smtp-Source: APiQypImmMB49AgGl1BnBc0wcKFgqit9q6XYYifrmzA6W040jedeCZWXN8p6VY69AT0qDUZKGUxJdWq4qHdmn/56g6U=
X-Received: by 2002:a05:6602:2cc4:: with SMTP id j4mr20392563iow.144.1587476647207;
 Tue, 21 Apr 2020 06:44:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200416162715.45846-1-ldufour@linux.ibm.com> <87k129gdx8.fsf@mpe.ellerman.id.au>
In-Reply-To: <87k129gdx8.fsf@mpe.ellerman.id.au>
From:   "Oliver O'Halloran" <oohall@gmail.com>
Date:   Tue, 21 Apr 2020 23:43:56 +1000
Message-ID: <CAOSf1CF2YEG1U_1XP_Vvk3Bn1RCiNa1DAKEbemWu00JimoPsUQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: read ibm,secure-memory nodes
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Laurent Dufour <ldufour@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Apr 21, 2020 at 11:37 PM Michael Ellerman <mpe@ellerman.id.au> wrote:
>
> Hi Laurent,
>
> Laurent Dufour <ldufour@linux.ibm.com> writes:
> > The newly introduced ibm,secure-memory nodes supersede the
> > ibm,uv-firmware's property secure-memory-ranges.
>
> Is either documented in a device tree binding document anywhere?
>
> cheers
>
> > Firmware will no more expose the secure-memory-ranges property so first
> > read the new one and if not found rollback to the older one.

There's some in Ryan's UV support series for skiboot:

https://patchwork.ozlabs.org/project/skiboot/patch/20200227204023.22125-2-grimm@linux.ibm.com/

...which is also marked RFC. Cool.

Oliver

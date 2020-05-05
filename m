Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B3D1C5DFD
	for <lists+kvm-ppc@lfdr.de>; Tue,  5 May 2020 18:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbgEEQyL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 5 May 2020 12:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730093AbgEEQyG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 5 May 2020 12:54:06 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D799C0610D6
        for <kvm-ppc@vger.kernel.org>; Tue,  5 May 2020 09:54:05 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y26so1513279ioj.2
        for <kvm-ppc@vger.kernel.org>; Tue, 05 May 2020 09:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CQPV38VFHq5jUdj3xuK872aLx1CmmM995oAhTR/zeg4=;
        b=p0OmBMiNRcbZeEVttRyrUydpDTEXD+loILZwadE01yiYrZMAefBa5lEnkCd8IE/f1C
         wqtNt3itnutwU9SNyU/Y0fQOnPrSFTEoDV1obS+naK5wdvSAbwcozgcVIGkY/Otjnd9p
         51XhOstTUsx5ISmBzOTD1jNv/oS5q27DmqmWhYSeqm+5U94xAJaIyLgweW34StzfEErI
         3dfM/v0XMGcRAFe9bPtoLVFLg5ACcy1j8Rnan0JmxmJvsltfDo9KWXkcjYgZK/TvXSRC
         Oh/P44Cii0cxHTkyJ4tN2a3504hNbCU0BEhwsSTKenaJXoMTLVbgu3JdVv36Y/5fs6vB
         BO9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CQPV38VFHq5jUdj3xuK872aLx1CmmM995oAhTR/zeg4=;
        b=qFPFdRMPR4omcWgZlnueFWTib1G2T1x42oKBMZQiix0PGZV3vwr1wKm5ouE8Rpe/da
         0eyxyf6jQR56VJJwa9f7PIU9Y+yOqeThugnn6gxgbhtm+nAx6pCAkdz/Ah3bmjMaAalF
         BsSPX2DIs7s9VBnrWXTSnMAUAG8AD74gY3T6j4lB8A+VbruRA3nGxjL7HgAnENYteJbf
         /JRjuSnibL4D8VWqFMldUbzLvV7H/900WZOLjv9nTOn4Con+MjtLpYfl7SmkVb5HS3LU
         mJ5nhCXhx9je4wotvacU0Wjx56wwGiQZ2EQJfLZFd+/K9/8BoUlT/0QAEokV5SyKqcS/
         92Iw==
X-Gm-Message-State: AGi0Pub3MxkCOY9WKxltHhMhThNlzcYr37Xa6rKq3sPm2qRZc7YH/U17
        NJI/8jaMZqTrdaHQc1UXUirP81YEmeY/lPnqvbGlOA==
X-Google-Smtp-Source: APiQypIh87tWtIMtuteWC1af3Q4H+FkjslZ8xyNvCG2aA394n3dc+bOaNgbwVm/hpp4CR/gsTCwAOETr4pzr5lry2Mw=
X-Received: by 2002:a02:a004:: with SMTP id a4mr3700717jah.18.1588697644142;
 Tue, 05 May 2020 09:54:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200504110344.17560-1-eesposit@redhat.com> <alpine.DEB.2.22.394.2005041429210.224786@chino.kir.corp.google.com>
 <f2654143-b8e5-5a1f-8bd0-0cb0df2cd638@redhat.com>
In-Reply-To: <f2654143-b8e5-5a1f-8bd0-0cb0df2cd638@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 5 May 2020 09:53:53 -0700
Message-ID: <CALMp9eQYcLr_REzDC1kWTHX4SJWt7x+Zd1KwNvS1YGd5TVM1xA@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Statsfs: a new ram-based file sytem for Linux
 kernel statistics
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, May 5, 2020 at 2:18 AM Emanuele Giuseppe Esposito
<eesposit@redhat.com> wrote:
>
>
>
> On 5/4/20 11:37 PM, David Rientjes wrote:
> > Since this is becoming a generic API (good!!), maybe we can discuss
> > possible ways to optimize gathering of stats in mass?
>
> Sure, the idea of a binary format was considered from the beginning in
> [1], and it can be done either together with the current filesystem, or
> as a replacement via different mount options.

ASCII stats are not scalable. A binary format is definitely the way to go.

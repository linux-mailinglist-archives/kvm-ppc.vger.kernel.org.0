Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C331A3DBDBC
	for <lists+kvm-ppc@lfdr.de>; Fri, 30 Jul 2021 19:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhG3RcC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 30 Jul 2021 13:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhG3RcC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 30 Jul 2021 13:32:02 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323CEC061765
        for <kvm-ppc@vger.kernel.org>; Fri, 30 Jul 2021 10:31:56 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id h14so19317264lfv.7
        for <kvm-ppc@vger.kernel.org>; Fri, 30 Jul 2021 10:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rEJcSA2IPmkKQsknzGUJ8uAmtRXAnobazZDES9OmPiA=;
        b=OE80SPuMPEE4aXxV1WMPQTqeE5Rm3NfvJCTCtili64uWEiQTjXetpimt52x2lbWZF9
         2/BhKaoWhyNbsYamg0BVOQeI6zSVza/2Vv3n3IMFvAH7VG2AqnkloWhQKoWUkpxyqmak
         1s3k4eHzssGFvVe9cDSkkibagLs5Y/M4Z4ila9FcfZMv93lwR6zX7YGJzA6XQ4wCvmQC
         qpx/ppC9Kw37hIQsWENokFxypK83NY84ZCriz2+zV673drp0CAZCqAN6zzqntJ64V0k+
         99wQiepzXVnPyl1YoNf1cZNCtd5dm2BkxbWffMhCqnfdtsphUb2RX5ayxsiPPo3N4qbn
         vO2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rEJcSA2IPmkKQsknzGUJ8uAmtRXAnobazZDES9OmPiA=;
        b=PCCk4LD8sjKZS+lJWYzR2DX/B47Yb/wSb/mr7LFgZLtf3JXmkO2sf0c0vbFP/rgR+m
         htZDiIJWRtk9ReZD03uy1E3eMxuimP3NDGpGy3LE3hBYMpb99OTGdmO5GxdczrgXLyvU
         Kvsl/A7W0dV2Qh60G2kp/ZkuN+FEgwXDI9QyswTYDQtEbKazyLPqJnO4rCzeCwRiDu0t
         aKWb8KzDfPypxlgVekdPEgU9/LkM9GbJ2rxUtsmT8MCat6fVF0O/QJ1hzcev2GhvdO/W
         HBlG9D2vJlpIw6dcb4FkTfyZsupT1osdz2/IImclVL9Yw68yCtoche57imvL2eCe2Jc9
         Iwuw==
X-Gm-Message-State: AOAM531uUkiSxBdAj9KFSGFxkFh0UsmpGFPLqS+ZcYOKOXnkgBreLqD3
        c9MFxfFzhgwXzYM9PtroELVmDldwTTvwwFGyr36fEJJuiDA=
X-Google-Smtp-Source: ABdhPJwRt+6HcpUERxYL8Y78SiRl5pkHNGZ1Dy1A0OCkaOZixlY5EVKSv/L45tBArORrhkErfgibLipSkZhfvjfM0J8=
X-Received: by 2002:a05:6512:218e:: with SMTP id b14mr2603583lft.178.1627666314257;
 Fri, 30 Jul 2021 10:31:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210706180350.2838127-1-jingzhangos@google.com>
 <20210706180350.2838127-2-jingzhangos@google.com> <8b6f442e-c8bd-d175-471e-6e28b4548c3e@redhat.com>
In-Reply-To: <8b6f442e-c8bd-d175-471e-6e28b4548c3e@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 30 Jul 2021 10:31:43 -0700
Message-ID: <CAAdAUtiC9D=LkZTFDNMUfPXFGAbVvdEvXWAJSznZYA_T7KB8_A@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] KVM: stats: Support linear and logarithmic
 histogram statistics
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Jul 28, 2021 at 5:39 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 06/07/21 20:03, Jing Zhang wrote:
> > +#define LINHIST_SIZE_SMALL           10
> > +#define LINHIST_SIZE_MEDIUM          20
> > +#define LINHIST_SIZE_LARGE           50
> > +#define LINHIST_SIZE_XLARGE          100
> > +#define LINHIST_BUCKET_SIZE_SMALL    10
> > +#define LINHIST_BUCKET_SIZE_MEDIUM   100
> > +#define LINHIST_BUCKET_SIZE_LARGE    1000
> > +#define LINHIST_BUCKET_SIZE_XLARGE   10000
> > +
> > +#define LOGHIST_SIZE_SMALL           8
> > +#define LOGHIST_SIZE_MEDIUM          16
> > +#define LOGHIST_SIZE_LARGE           32
> > +#define LOGHIST_SIZE_XLARGE          64
> > +#define LOGHIST_BASE_2                       2
>
> I'd prefer inlining all of these.  For log histograms use 2 directly in
> STATS_DESC_LOG_HIST, since the update function below uses fls64.
>
Sure, will inline these values.
Will remove the loghist base, since base 2 log is enough for any
number. No other base is needed.
> >
> > + */
> > +void kvm_stats_linear_hist_update(u64 *data, size_t size,
> > +                               u64 value, size_t bucket_size)
> > +{
> > +     size_t index = value / bucket_size;
> > +
> > +     if (index >= size)
> > +             index = size - 1;
> > +     ++data[index];
> > +}
> > +
>
> Please make this function always inline, so that the compiler optimizes
> the division.
Sure.
>
> Also please use array_index_nospec to clamp the index to the size, in
> case value comes from a memory access as well.  Likewise for
> kvm_stats_log_hist_update.
Thanks. Will do.
>
> Paolo
>

Jing

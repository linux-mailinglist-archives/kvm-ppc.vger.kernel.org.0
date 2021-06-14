Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F4F3A5F72
	for <lists+kvm-ppc@lfdr.de>; Mon, 14 Jun 2021 11:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbhFNJxq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 14 Jun 2021 05:53:46 -0400
Received: from mail-oo1-f49.google.com ([209.85.161.49]:45737 "EHLO
        mail-oo1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbhFNJxp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 14 Jun 2021 05:53:45 -0400
Received: by mail-oo1-f49.google.com with SMTP id q20-20020a4a6c140000b029024915d1bd7cso2498112ooc.12
        for <kvm-ppc@vger.kernel.org>; Mon, 14 Jun 2021 02:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ozeCrBWe056dvCFaSIn+YQtzRjUNyCG2jQsSBdsH6g=;
        b=K2qC92mVnZ7jUjofUEv4H+1w+qvltenXJMO5pP5zAQH9F9zzM6cma5PhaHyikSIE3D
         dgQc6WK4VWss1I8rQpcUAa+kknrISK1OThLKqPD0Ynu3YYr8NHxDjWdGBi55WyPUNLif
         i3JnBKWMJgfPTrRirLFRa8yVdEoj3gif50MFdkhnQ7QcHt3pdY8TR72cKPAlAymhZAhy
         fE+SeGXJkHhWdl5z0so4A3sE6OP4b04IsNaed/cw6QlyOjQcCpURRrlseuX+X6B4TqU1
         wFpbS04rbYoW9naTxekf9c4HpCWGlieaJNAtYseO4lXhzKvQiMv8Gd3ijQNtsUu8qwFY
         4JHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ozeCrBWe056dvCFaSIn+YQtzRjUNyCG2jQsSBdsH6g=;
        b=q3rxbumJ6GEfOceOI+iWRzo9WlN0v6brcZocm6vn7cGJFKeK4lF6dxA73WeT50XKz7
         bTzer3hXtzvvQuCeOjsvFtHOJ2TS9mONXEMoc+d8p2jeXdYiDr0wWKq2rl7a51ss9uqL
         GU18d9VmqlTwxrDy2Uyi3cvEDtKB2/puSeYcNeirMO7Cy+L04ngTcvHhgRlCIy5iqVjT
         N/J6ZPAvM4hwRtW03jCQGzD826jrQvHmWEh0DekboRXsHtBA0fJ4jKjf+aJ30VB0KAgW
         v6I67Sc0drPwgGSi+515CfOGeSK6lhgihnYAKbY+FZzZr/LlgScH3niWsUGXcgBY89yb
         UT7Q==
X-Gm-Message-State: AOAM530sff900QmPGMGuQ8r+aZEk7uMT6N5WJH7W+4qJjmpzIu5wo3AK
        oRMMhuP764DBC37qyfDrFVtUALxHapk1EkPL8U6lxQ==
X-Google-Smtp-Source: ABdhPJyJwQ95jW5MLr7rUkCdRFLkVYE33n19WoUneoHj3ZP6RKTjyoGOcQr4wTLfnQTTpVHh3eZs+F2r0ncYGstNVYw=
X-Received: by 2002:a4a:5482:: with SMTP id t124mr12435372ooa.42.1623664227170;
 Mon, 14 Jun 2021 02:50:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210614025351.365284-1-jingzhangos@google.com> <20210614025351.365284-2-jingzhangos@google.com>
In-Reply-To: <20210614025351.365284-2-jingzhangos@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 14 Jun 2021 10:49:50 +0100
Message-ID: <CA+EHjTybUkOVVByL5r_MwLfzc_aaPybY8AzdCLYmS8aiR-RkSA@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: stats: Make sure no missing or mismatched binary
 stats definition
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Jing,

On Mon, Jun 14, 2021 at 3:53 AM Jing Zhang <jingzhangos@google.com> wrote:
>
> Add static check to make sure the number of stats descriptors equals
> the number of stats defined in vm/vcpu stats structures.
> Add offset field in stats descriptor to let us define stats
> descriptors freely, don't have to be in the same order as
> stats in vm/vcpu stats structures.
> Also fix some missing/mismatched stats from previous patch.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>

I tested this for arm64, and it does assert if there's a mismatch. I
couldn't find any missing statistics under any of the architectures
either.

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 5e77f32abef5..692af9177c9f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1296,119 +1296,152 @@ struct _kvm_stats_desc {
>         { n, offsetof(struct kvm_vcpu, stat.generic.x),                        \
>           KVM_STAT_VCPU, ## __VA_ARGS__ }
>
> -#define STATS_DESC(stat, type, unit, base, exp)                               \
> +#define STATS_DESC_COMMON(type, unit, base, exp)                              \
> +       .flags = type | unit | base |                                          \
> +           BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |                   \
> +           BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |                   \
> +           BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),                    \
> +       .exponent = exp,                                                       \
> +       .size = 1
> +

nit: you seem to be mixing tabs and spaces here

> +#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp)                    \
>         {                                                                      \
>                 {                                                              \
> -                       .flags = type | unit | base |                          \
> -                           BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |   \
> -                           BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |   \
> -                           BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),    \
> -                       .exponent = exp,                                       \
> -                       .size = 1                                              \
> +                       STATS_DESC_COMMON(type, unit, base, exp),              \
> +                       .offset = offsetof(struct kvm_vm_stat, generic.stat)   \
>                 },                                                             \
> -               .name = stat,                                                  \
> +               .name = #stat,                                                 \
>         }

nit: also here, mixing of tabs and spaces

Tested-by: Fuad Tabba <tabba@google.com> #arm64
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

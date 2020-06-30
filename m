Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8AE20EB2C
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Jun 2020 03:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgF3B6l (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 29 Jun 2020 21:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgF3B6j (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 29 Jun 2020 21:58:39 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0989C061755
        for <kvm-ppc@vger.kernel.org>; Mon, 29 Jun 2020 18:58:39 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id b6so18470576wrs.11
        for <kvm-ppc@vger.kernel.org>; Mon, 29 Jun 2020 18:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=k6wRh3ytme3gPSlALKJl6wuK0hUmcexe6Z7bwnzkD9I=;
        b=dFbydKyQLV5QX3J4VY9869CPSiZaD228wHrj0M2Z2D8yRuWI9THsp+7kDikYjL6saL
         OGdEcktIGk/kF9VZj+84bJ2awzhsNdRjflSsUNxCPQl4mniXAOAV8XSDgigJ3xHFA87m
         JE8kDhWuc0rQKPSwYLy7SrvQqiVUScaeRo4jnlantr5w6ThKvGm8KLn951bzxyt5uIk4
         jE/qFpSZGKzuHFz2jwQ3LrRpHkQb+1ZoF7sPUHf78rq9w5M83a1on9Bf9LWWUcLrK0+6
         GpFnhzDIBxAdxGNEK33hh8FSWXh9yxabxEXGEhxXd1kU7IZwsAjaNxHLFXhv7KOQHHuM
         37Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=k6wRh3ytme3gPSlALKJl6wuK0hUmcexe6Z7bwnzkD9I=;
        b=Ud8/b1bNxztBAXjtrtCyzWupCgRyhPhm08NS+MzyqkUIFlcG73z8kQu41H8ncB0KVX
         pciEBH376/O9YKXdIiPp4c47VtaJfZObYD7Cvhc76mgq04JBmwnGYipSZIgipr0UdZXe
         CfQuNfmpVsmUd2u6Zkafr5RLIGyfN4nnJKhn4XV8e7cV1hkwauRak5MqWZ4KaJcqAIfr
         SYXADY0I9tmSkItsnUvnyuVj+NJh8MSz3TkAwpTZxyvcX8EW3WmlexDVfrT86a7o7UR3
         by3BQMBsaIvqmFYKQDZzQ1KKq3FxYbUHdolZAmWNcaiup4FsLdSbhFknEYX0EFxv6XWa
         dm8w==
X-Gm-Message-State: AOAM530ljq6xK7eCZRDgStjoQ2NOy0LUBfz224Mg5rCpwl9Tsjs4883z
        oELF4OIbll0O/P5oyxrRsAg=
X-Google-Smtp-Source: ABdhPJxu7q0WxuSIpUAdZqmDn2LZ96oyRft2Mpcbf6AUyK05/ie1YP8kwX/ibQJEGKtCZqLJfmov/A==
X-Received: by 2002:adf:f34f:: with SMTP id e15mr19723464wrp.415.1593482318118;
        Mon, 29 Jun 2020 18:58:38 -0700 (PDT)
Received: from localhost (61-68-186-125.tpgi.com.au. [61.68.186.125])
        by smtp.gmail.com with ESMTPSA id a15sm2011397wrh.54.2020.06.29.18.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 18:58:37 -0700 (PDT)
Date:   Tue, 30 Jun 2020 11:58:30 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 1/3] powerpc: inline doorbell sending functions
To:     linuxppc-dev@lists.ozlabs.org, kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Anton Blanchard <anton@linux.ibm.com>,
        =?iso-8859-1?q?C=E9dric?= Le Goater <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        kbuild-all@lists.01.org, kvm-ppc@vger.kernel.org
References: <20200627150428.2525192-2-npiggin@gmail.com>
        <202006280326.fcRFUNzs%lkp@intel.com> <87zh8l7318.fsf@mpe.ellerman.id.au>
In-Reply-To: <87zh8l7318.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Message-Id: <1593482195.vpy5eylip3.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Michael Ellerman's message of June 30, 2020 11:31 am:
> kernel test robot <lkp@intel.com> writes:
>> Hi Nicholas,
>>
>> I love your patch! Yet something to improve:
>>
>> [auto build test ERROR on powerpc/next]
>> [also build test ERROR on scottwood/next v5.8-rc2 next-20200626]
>> [cannot apply to kvm-ppc/kvm-ppc-next]
>> [If your patch is applied to the wrong git tree, kindly drop us a note.
>> And when submitting patch, we suggest to use  as documented in
>> https://git-scm.com/docs/git-format-patch]
>>
>> url:    https://github.com/0day-ci/linux/commits/Nicholas-Piggin/powerpc=
-pseries-IPI-doorbell-improvements/20200627-230544
>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.gi=
t next
>> config: powerpc-randconfig-c003-20200628 (attached as .config)
>> compiler: powerpc64-linux-gcc (GCC) 9.3.0
>=20
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>>
>> All error/warnings (new ones prefixed by >>):
>>
>>    In file included from arch/powerpc/kernel/asm-offsets.c:38:
>>    arch/powerpc/include/asm/dbell.h: In function 'doorbell_global_ipi':
>>>> arch/powerpc/include/asm/dbell.h:114:12: error: implicit declaration o=
f function 'get_hard_smp_processor_id'; did you mean 'raw_smp_processor_id'=
? [-Werror=3Dimplicit-function-declaration]
>>      114 |  u32 tag =3D get_hard_smp_processor_id(cpu);
>>          |            ^~~~~~~~~~~~~~~~~~~~~~~~~
>>          |            raw_smp_processor_id
>>    arch/powerpc/include/asm/dbell.h: In function 'doorbell_try_core_ipi'=
:
>>>> arch/powerpc/include/asm/dbell.h:146:28: error: implicit declaration o=
f function 'cpu_sibling_mask'; did you mean 'cpu_online_mask'? [-Werror=3Di=
mplicit-function-declaration]
>>      146 |  if (cpumask_test_cpu(cpu, cpu_sibling_mask(this_cpu))) {
>>          |                            ^~~~~~~~~~~~~~~~
>>          |                            cpu_online_mask
>>>> arch/powerpc/include/asm/dbell.h:146:28: warning: passing argument 2 o=
f 'cpumask_test_cpu' makes pointer from integer without a cast [-Wint-conve=
rsion]
>>      146 |  if (cpumask_test_cpu(cpu, cpu_sibling_mask(this_cpu))) {
>>          |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~
>=20
> Seems like CONFIG_SMP=3Dn is probably the root cause.
>=20
> You could try including asm/smp.h, but good chance that will lead to
> header soup.

Possibly. dbell.h shouldn't be included by much, but maybe it gets
dragged in.

>=20
> Other option would be to wrap the whole lot in #ifdef CONFIG_SMP?

Yeah that might be a better idea.

I'll fix it up and repost if there's no strong objections to
the KVM detection bit.

Thanks,
Nick

Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF22C1625CB
	for <lists+kvm-ppc@lfdr.de>; Tue, 18 Feb 2020 12:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgBRLxY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 18 Feb 2020 06:53:24 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:42479 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbgBRLxY (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 18 Feb 2020 06:53:24 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48MK4K0wsLz9sRG;
        Tue, 18 Feb 2020 22:53:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1582026801;
        bh=L6BJzj9vw4s6lyjMRtWdcr4bYuLX+l2N7WBaWS3PrSs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=L27A9Sg33AuJloFv7jLtXn9oLaSa5FnYgBYQSu4Fl1GVoJgghoeJrvfkt7qnU/b1A
         4D+UerBpjUUGus0szeu7dAcXRaebwtqzbKrMhEKcBCPc1fQW2qQyZFtgoRAAChVzY4
         Ufdm9rGGjrrRgn8mXac/E9+CFd8+GK8f2Es1oqjbnrQUv8Oa+c57cmlCks7ZDDSWGO
         nPTZM5c0esile5FaTEvFb1LmGoUXe6lgwu6uFTiW1yWAiS3W0ZB3ivxdzM8PiPfLs3
         oUaY/bQKb6psIgdgTCQokwPZvcLaSUYgpInhvMGGc14Fb4UMF7VlEKj+oZ4hY5mGcm
         T/irj+PT672Bg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH kernel v3] powerpc/book3s64: Fix error handling in mm_iommu_do_alloc()
In-Reply-To: <52916c5e-7c4e-9b3e-8fbd-12dad8e00611@ozlabs.ru>
References: <20191223060351.26359-1-aik@ozlabs.ru> <87mubjl27j.fsf@mpe.ellerman.id.au> <56e98c75-ea44-6805-4bd3-c41620834e9e@ozlabs.ru> <52916c5e-7c4e-9b3e-8fbd-12dad8e00611@ozlabs.ru>
Date:   Tue, 18 Feb 2020 22:53:20 +1100
Message-ID: <87zhdgdscv.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Alexey Kardashevskiy <aik@ozlabs.ru> writes:
> On 24/12/2019 10:32, Alexey Kardashevskiy wrote:
...
>> 
>> I could rearrange the code even more but since there is no NVLink3
>> coming ever, I'd avoid changing it more than necessary. Thanks,
>
> Repost? Rework?

I'll just take v3.

cheers

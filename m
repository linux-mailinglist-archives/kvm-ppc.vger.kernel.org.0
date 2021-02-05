Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D3C31187D
	for <lists+kvm-ppc@lfdr.de>; Sat,  6 Feb 2021 03:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhBFCjS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Feb 2021 21:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhBFCew (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Feb 2021 21:34:52 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1387C08ED81;
        Fri,  5 Feb 2021 15:33:04 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DXWtg3J8rz9sVq;
        Sat,  6 Feb 2021 10:32:59 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1612567981;
        bh=YEW0go1tFxFTxPolBx8L31xUfYen5gFpEkFsTBzAGzI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=HIpXaQUIpsnljSZbduOd3aUyuZSR5xDnELAdF1j+5z/HWCYImoa+1yAm1XltVrrvv
         D33mnCqMEFECxr9UnWzV1mvmfmkqsbcJr5f3aITbibDk5vjienHXHJMRbEI12PDhqK
         gI3BeEz2UjvpjcBHeEn4bGI/EcmPBUU1fiSljcQRZEFvTgZnVlVf/gaGg4kEjv8RA0
         SFBAju1jx5nuVG35gO2HG74GoQhFmiVjbJZASsr1ftGXA5uVvfkCt5k/E7LAyDyKi8
         oN9TZIft6KvJvKjwgvOvNChlr4QYR3rhkgjgj8oMkPrj1k7h69noE05DZPEN/SDELL
         nKIfAUDWlTobQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Frederic Weisbecker <frederic@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jordan Niethe <jniethe5@gmail.com>,
        Leonardo Bras <leobras.c@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 1/1] powerpc/kvm: Save Timebase Offset to fix
 sched_clock() while running guest code.
In-Reply-To: <1612506268.6rrvx34gzu.astroid@bobo.none>
References: <20210205060643.233481-1-leobras.c@gmail.com>
 <1612506268.6rrvx34gzu.astroid@bobo.none>
Date:   Sat, 06 Feb 2021 10:32:58 +1100
Message-ID: <878s82ozth.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:
> Excerpts from Leonardo Bras's message of February 5, 2021 4:06 pm:
>> Before guest entry, TBU40 register is changed to reflect guest timebase.
>> After exitting guest, the register is reverted to it's original value.
>> 
>> If one tries to get the timestamp from host between those changes, it
>> will present an incorrect value.
>> 
>> An example would be trying to add a tracepoint in
>> kvmppc_guest_entry_inject_int(), which depending on last tracepoint
>> acquired could actually cause the host to crash.
>> 
>> Save the Timebase Offset to PACA and use it on sched_clock() to always
>> get the correct timestamp.
>
> Ouch. Not sure how reasonable it is to half switch into guest registers 
> and expect to call into the wider kernel, fixing things up as we go. 

Yeah it's not.

We need to disable tracing on those routines that are called in that
half-exited state.

cheers

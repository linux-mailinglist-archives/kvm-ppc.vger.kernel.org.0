Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF88D5F4431
	for <lists+kvm-ppc@lfdr.de>; Tue,  4 Oct 2022 15:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiJDNW2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 4 Oct 2022 09:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiJDNW1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 4 Oct 2022 09:22:27 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759BA25F0
        for <kvm-ppc@vger.kernel.org>; Tue,  4 Oct 2022 06:22:26 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MhdfN4svqz4xGj;
        Wed,  5 Oct 2022 00:22:20 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Fabiano Rosas <farosas@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     npiggin@gmail.com, kvm-ppc@vger.kernel.org
In-Reply-To: <20220816222517.1916391-1-farosas@linux.ibm.com>
References: <20220816222517.1916391-1-farosas@linux.ibm.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix decrementer migration
Message-Id: <166488970203.778266.13672388386206891818.b4-ty@ellerman.id.au>
Date:   Wed, 05 Oct 2022 00:21:42 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 16 Aug 2022 19:25:17 -0300, Fabiano Rosas wrote:
> We used to have a workaround[1] for a hang during migration that was
> made ineffective when we converted the decrementer expiry to be
> relative to guest timebase.
> 
> The point of the workaround was that in the absence of an explicit
> decrementer expiry value provided by userspace during migration, KVM
> needs to initialize dec_expires to a value that will result in an
> expired decrementer after subtracting the current guest timebase. That
> stops the vcpu from hanging after migration due to a decrementer
> that's too large.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: Book3S HV: Fix decrementer migration
      https://git.kernel.org/powerpc/c/0a5bfb824a6ea35e54b7e5ac6f881beea5e309d2

cheers

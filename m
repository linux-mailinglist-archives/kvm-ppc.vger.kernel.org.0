Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBAD256C8ED
	for <lists+kvm-ppc@lfdr.de>; Sat,  9 Jul 2022 12:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiGIKSM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 9 Jul 2022 06:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiGIKSL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 9 Jul 2022 06:18:11 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15A93CBF2
        for <kvm-ppc@vger.kernel.org>; Sat,  9 Jul 2022 03:18:10 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Lg5h12vQYz4xvW;
        Sat,  9 Jul 2022 20:18:09 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Cc:     npiggin@gmail.com, kvm-ppc@vger.kernel.org, muriloo@linux.ibm.com
In-Reply-To: <20220624142712.790491-1-farosas@linux.ibm.com>
References: <20220624142712.790491-1-farosas@linux.ibm.com>
Subject: Re: [PATCH v2] KVM: PPC: Align pt_regs in kvm_vcpu_arch structure
Message-Id: <165736167068.12236.7214130104736401975.b4-ty@ellerman.id.au>
Date:   Sat, 09 Jul 2022 20:14:30 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, 24 Jun 2022 11:27:12 -0300, Fabiano Rosas wrote:
> The H_ENTER_NESTED hypercall receives as second parameter the address
> of a region of memory containing the values for the nested guest
> privileged registers. We currently use the pt_regs structure contained
> within kvm_vcpu_arch for that end.
> 
> Most hypercalls that receive a memory address expect that region to
> not cross a 4K page boundary. We would want H_ENTER_NESTED to follow
> the same pattern so this patch ensures the pt_regs structure sits
> within a page.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: Align pt_regs in kvm_vcpu_arch structure
      https://git.kernel.org/powerpc/c/f5c847ea19d323974d6f7c7e9fa4858ce0727096

cheers

Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F270532843
	for <lists+kvm-ppc@lfdr.de>; Tue, 24 May 2022 12:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiEXKyB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 24 May 2022 06:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236383AbiEXKyB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 24 May 2022 06:54:01 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7078350049
        for <kvm-ppc@vger.kernel.org>; Tue, 24 May 2022 03:53:58 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L6rfT4cBTz4xYY;
        Tue, 24 May 2022 20:53:53 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org
In-Reply-To: <20220506073737.3823347-1-aik@ozlabs.ru>
References: <20220506073737.3823347-1-aik@ozlabs.ru>
Subject: Re: [PATCH kernel] KVM: PPC: Book3s: PR: Enable default TCE hypercalls
Message-Id: <165338951230.1711920.13309403360351768244.b4-ty@ellerman.id.au>
Date:   Tue, 24 May 2022 20:51:52 +1000
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

On Fri, 6 May 2022 17:37:37 +1000, Alexey Kardashevskiy wrote:
> When KVM_CAP_PPC_ENABLE_HCALL was introduced, H_GET_TCE and H_PUT_TCE
> were already implemented and enabled by default; however H_GET_TCE
> was missed out on PR KVM (probably because the handler was in
> the real mode code at the time).
> 
> This enables H_GET_TCE by default. While at this, this wraps
> the checks in ifdef CONFIG_SPAPR_TCE_IOMMU just like HV KVM.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: Book3s: PR: Enable default TCE hypercalls
      https://git.kernel.org/powerpc/c/29592181c5496d93697a23e6dbb9d7cc317ff5ee

cheers

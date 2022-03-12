Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40EC4D6E38
	for <lists+kvm-ppc@lfdr.de>; Sat, 12 Mar 2022 11:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiCLKkt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 12 Mar 2022 05:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiCLKks (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 12 Mar 2022 05:40:48 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D99BB6
        for <kvm-ppc@vger.kernel.org>; Sat, 12 Mar 2022 02:39:43 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KFznp3bJRz4xLT;
        Sat, 12 Mar 2022 21:39:42 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     aik@ozlabs.ru, npiggin@gmail.com, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20220125155735.1018683-1-farosas@linux.ibm.com>
References: <20220125155735.1018683-1-farosas@linux.ibm.com>
Subject: Re: [PATCH v3 0/4] KVM: PPC: KVM module exit fixes
Message-Id: <164708144610.832402.1913966629226492244.b4-ty@ellerman.id.au>
Date:   Sat, 12 Mar 2022 21:37:26 +1100
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

On Tue, 25 Jan 2022 12:57:31 -0300, Fabiano Rosas wrote:
> changes from v2:
> 
> - patch 4: Matched module_put() to try_module_get()
> 
> v2:
> https://lore.kernel.org/r/20220124220803.1011673-1-farosas@linux.ibm.com
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/4] KVM: PPC: Book3S HV: Check return value of kvmppc_radix_init
      https://git.kernel.org/powerpc/c/69ab6ac380a00244575de02c406dcb9491bf3368
[2/4] KVM: PPC: Book3S HV: Delay setting of kvm ops
      https://git.kernel.org/powerpc/c/c5d0d77b45265905bba2ce6e63c9a02bbd11c43c
[3/4] KVM: PPC: Book3S HV: Free allocated memory if module init fails
      https://git.kernel.org/powerpc/c/175be7e5800e2782a7e38ee9e1b64633494c4b44
[4/4] KVM: PPC: Decrement module refcount if init_vm fails
      https://git.kernel.org/powerpc/c/4feb74aa64b35b21a4937f96d7a940adee286e5b

cheers

Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B25554A55
	for <lists+kvm-ppc@lfdr.de>; Wed, 22 Jun 2022 14:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240672AbiFVMvw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm-ppc@lfdr.de>); Wed, 22 Jun 2022 08:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235799AbiFVMvv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 22 Jun 2022 08:51:51 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC65915FD1
        for <kvm-ppc@vger.kernel.org>; Wed, 22 Jun 2022 05:51:49 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-bMR0t5tvPzC-aze2xY3N8g-1; Wed, 22 Jun 2022 08:51:45 -0400
X-MC-Unique: bMR0t5tvPzC-aze2xY3N8g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E3AF85A585;
        Wed, 22 Jun 2022 12:51:45 +0000 (UTC)
Received: from bahia (unknown [10.39.192.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5237E1131D;
        Wed, 22 Jun 2022 12:51:43 +0000 (UTC)
Date:   Wed, 22 Jun 2022 14:51:42 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     <linuxppc-dev@lists.ozlabs.org>, <kvm-ppc@vger.kernel.org>
Subject: Re: [PATCH kernel] KVM: PPC: Book3s: Fix warning about
 xics_rm_h_xirr_x
Message-ID: <20220622145142.53c3668f@bahia>
In-Reply-To: <20220622055235.1139204-1-aik@ozlabs.ru>
References: <20220622055235.1139204-1-aik@ozlabs.ru>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kaod.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 22 Jun 2022 15:52:35 +1000
Alexey Kardashevskiy <aik@ozlabs.ru> wrote:

> This fixes "no previous prototype":
> 
> arch/powerpc/kvm/book3s_hv_rm_xics.c:482:15:
> warning: no previous prototype for 'xics_rm_h_xirr_x' [-Wmissing-prototypes]
> 
> Reported by the kernel test robot.
> 
> Fixes: b22af9041927 ("KVM: PPC: Book3s: Remove real mode interrupt controller hcalls handlers")
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---

FWIW

Reviewed-by: Greg Kurz <groug@kaod.org>

>  arch/powerpc/kvm/book3s_xics.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/powerpc/kvm/book3s_xics.h b/arch/powerpc/kvm/book3s_xics.h
> index 8e4c79e2fcd8..08fb0843faf5 100644
> --- a/arch/powerpc/kvm/book3s_xics.h
> +++ b/arch/powerpc/kvm/book3s_xics.h
> @@ -143,6 +143,7 @@ static inline struct kvmppc_ics *kvmppc_xics_find_ics(struct kvmppc_xics *xics,
>  }
>  
>  extern unsigned long xics_rm_h_xirr(struct kvm_vcpu *vcpu);
> +extern unsigned long xics_rm_h_xirr_x(struct kvm_vcpu *vcpu);
>  extern int xics_rm_h_ipi(struct kvm_vcpu *vcpu, unsigned long server,
>  			 unsigned long mfrr);
>  extern int xics_rm_h_cppr(struct kvm_vcpu *vcpu, unsigned long cppr);


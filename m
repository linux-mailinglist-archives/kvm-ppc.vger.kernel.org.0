Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDC444AE55
	for <lists+kvm-ppc@lfdr.de>; Wed, 19 Jun 2019 01:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbfFRXFk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 18 Jun 2019 19:05:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52524 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730377AbfFRXFk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 18 Jun 2019 19:05:40 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5IMvcqb101941
        for <kvm-ppc@vger.kernel.org>; Tue, 18 Jun 2019 19:05:38 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t7804jx99-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 18 Jun 2019 19:05:38 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bauerman@linux.ibm.com>;
        Wed, 19 Jun 2019 00:05:37 +0100
Received: from b01cxnp22036.gho.pok.ibm.com (9.57.198.26)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 19 Jun 2019 00:05:34 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5IN5Xdc35127798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 23:05:33 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01820AC05E;
        Tue, 18 Jun 2019 23:05:33 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5F6CAC059;
        Tue, 18 Jun 2019 23:05:30 +0000 (GMT)
Received: from morokweng.localdomain (unknown [9.80.212.11])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue, 18 Jun 2019 23:05:30 +0000 (GMT)
References: <20190528064933.23119-1-bharata@linux.ibm.com> <20190528064933.23119-4-bharata@linux.ibm.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Thiago Jung Bauermann <bauerman@linux.ibm.com>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com
Subject: Re: [PATCH v4 3/6] kvmppc: H_SVM_INIT_START and H_SVM_INIT_DONE hcalls
In-reply-to: <20190528064933.23119-4-bharata@linux.ibm.com>
Date:   Tue, 18 Jun 2019 20:05:26 -0300
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
x-cbid: 19061823-0072-0000-0000-0000043E34AC
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011287; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01219945; UDB=6.00641721; IPR=6.01001087;
 MB=3.00027366; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-18 23:05:35
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061823-0073-0000-0000-00004CAE3D5C
Message-Id: <87y31y7avd.fsf@morokweng.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=853 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180185
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


Hello Bharata,

Bharata B Rao <bharata@linux.ibm.com> writes:

> diff --git a/arch/powerpc/include/asm/kvm_book3s_hmm.h b/arch/powerpc/include/asm/kvm_book3s_hmm.h
> index 21f3de5f2acb..3e13dab7f690 100644
> --- a/arch/powerpc/include/asm/kvm_book3s_hmm.h
> +++ b/arch/powerpc/include/asm/kvm_book3s_hmm.h
> @@ -11,6 +11,8 @@ extern unsigned long kvmppc_h_svm_page_out(struct kvm *kvm,
>  					  unsigned long gra,
>  					  unsigned long flags,
>  					  unsigned long page_shift);
> +extern unsigned long kvmppc_h_svm_init_start(struct kvm *kvm);
> +extern unsigned long kvmppc_h_svm_init_done(struct kvm *kvm);
>  #else
>  static inline unsigned long
>  kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gra,
> @@ -25,5 +27,15 @@ kvmppc_h_svm_page_out(struct kvm *kvm, unsigned long gra,
>  {
>  	return H_UNSUPPORTED;
>  }
> +
> +static inine unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
> +{
> +	return H_UNSUPPORTED;
> +}
> +
> +static inine unsigned long kvmppc_h_svm_init_done(struct kvm *kvm);
> +{
> +	return H_UNSUPPORTED;
> +}
>  #endif /* CONFIG_PPC_UV */
>  #endif /* __POWERPC_KVM_PPC_HMM_H__ */

This patch won't build when CONFIG_PPC_UV isn't set because of two
typos: "inine" and the ';' at the end of kvmppc_h_svm_init_done()
function prototype.

-- 
Thiago Jung Bauermann
IBM Linux Technology Center


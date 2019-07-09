Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A302633E4
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Jul 2019 12:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfGIKFj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Jul 2019 06:05:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23794 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725989AbfGIKFi (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Jul 2019 06:05:38 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69A2HHE038582
        for <kvm-ppc@vger.kernel.org>; Tue, 9 Jul 2019 06:05:37 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tmqbxus66-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 09 Jul 2019 06:05:37 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Tue, 9 Jul 2019 11:05:35 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 9 Jul 2019 11:05:31 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x69A5Uds50069548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jul 2019 10:05:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F311AE045;
        Tue,  9 Jul 2019 10:05:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9ACFBAE04D;
        Tue,  9 Jul 2019 10:05:28 +0000 (GMT)
Received: from in.ibm.com (unknown [9.85.81.51])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  9 Jul 2019 10:05:28 +0000 (GMT)
Date:   Tue, 9 Jul 2019 15:35:26 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com
Subject: Re: [PATCH v4 3/6] kvmppc: H_SVM_INIT_START and H_SVM_INIT_DONE
 hcalls
Reply-To: bharata@linux.ibm.com
References: <20190528064933.23119-1-bharata@linux.ibm.com>
 <20190528064933.23119-4-bharata@linux.ibm.com>
 <87y31y7avd.fsf@morokweng.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y31y7avd.fsf@morokweng.localdomain>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-TM-AS-GCONF: 00
x-cbid: 19070910-0016-0000-0000-000002909329
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070910-0017-0000-0000-000032EE4575
Message-Id: <20190709100526.GC27933@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090122
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Jun 18, 2019 at 08:05:26PM -0300, Thiago Jung Bauermann wrote:
> 
> Hello Bharata,
> 
> Bharata B Rao <bharata@linux.ibm.com> writes:
> 
> > diff --git a/arch/powerpc/include/asm/kvm_book3s_hmm.h b/arch/powerpc/include/asm/kvm_book3s_hmm.h
> > index 21f3de5f2acb..3e13dab7f690 100644
> > --- a/arch/powerpc/include/asm/kvm_book3s_hmm.h
> > +++ b/arch/powerpc/include/asm/kvm_book3s_hmm.h
> > @@ -11,6 +11,8 @@ extern unsigned long kvmppc_h_svm_page_out(struct kvm *kvm,
> >  					  unsigned long gra,
> >  					  unsigned long flags,
> >  					  unsigned long page_shift);
> > +extern unsigned long kvmppc_h_svm_init_start(struct kvm *kvm);
> > +extern unsigned long kvmppc_h_svm_init_done(struct kvm *kvm);
> >  #else
> >  static inline unsigned long
> >  kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gra,
> > @@ -25,5 +27,15 @@ kvmppc_h_svm_page_out(struct kvm *kvm, unsigned long gra,
> >  {
> >  	return H_UNSUPPORTED;
> >  }
> > +
> > +static inine unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
> > +{
> > +	return H_UNSUPPORTED;
> > +}
> > +
> > +static inine unsigned long kvmppc_h_svm_init_done(struct kvm *kvm);
> > +{
> > +	return H_UNSUPPORTED;
> > +}
> >  #endif /* CONFIG_PPC_UV */
> >  #endif /* __POWERPC_KVM_PPC_HMM_H__ */
> 
> This patch won't build when CONFIG_PPC_UV isn't set because of two
> typos: "inine" and the ';' at the end of kvmppc_h_svm_init_done()
> function prototype.

Thanks. Fixed this.

Regards,
Bharata.


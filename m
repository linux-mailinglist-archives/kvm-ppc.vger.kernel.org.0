Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CFE32B118
	for <lists+kvm-ppc@lfdr.de>; Wed,  3 Mar 2021 04:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbhCCAnN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 2 Mar 2021 19:43:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58644 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239435AbhCBEP1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 1 Mar 2021 23:15:27 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12244SwS034717;
        Mon, 1 Mar 2021 23:14:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=Zcq8ZXTWc6KLodUpskIv84w8mifrjaFY9WHFDAzQZJU=;
 b=I4sJeUtl8PxmfGpnD99YN+3yo6bxt6O4Mc1gJyRPNBQiiKjgnFF5/IZKwxm0xJupE8jL
 tAB27hvobJW6zQfZv0al3uknKSDIp47Co2AtxEpzQkaBGXfJufjR0HlZ511Afx7V4XpB
 IGNI20qmpdvXIRmGqtdgYLP6K+kRB4oRN9DpT2kVHt+w2XRiQvo6c5p4Owu2mx1IrnHT
 daaWO94Ddus08N8jxE2tHtIq0hJc5UoN6LghSywRRs7Q4+xDj+psyShyywEKVQ8h6Lpo
 PcALNHP53NUssS48bRDErgpl/glGwhJ+GwbI1txtrwh46GAypifDJG30g+lii0CUGsEo 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371c25tu7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 23:14:37 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12245cLd037809;
        Mon, 1 Mar 2021 23:14:36 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371c25tu6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 23:14:36 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1224EYQY011743;
        Tue, 2 Mar 2021 04:14:34 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3712v508dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 04:14:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1224EV2531916398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 04:14:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E705342041;
        Tue,  2 Mar 2021 04:14:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68F134203F;
        Tue,  2 Mar 2021 04:14:29 +0000 (GMT)
Received: from in.ibm.com (unknown [9.199.51.221])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  2 Mar 2021 04:14:29 +0000 (GMT)
Date:   Tue, 2 Mar 2021 09:44:27 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Fabiano Rosas <farosas@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, david@gibson.dropbear.id.au
Subject: Re: [PATCH v5 2/3] KVM: PPC: Book3S HV: Add support for
 H_RPT_INVALIDATE
Message-ID: <20210302041427.GA188607@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <20210224082510.3962423-1-bharata@linux.ibm.com>
 <20210224082510.3962423-3-bharata@linux.ibm.com>
 <87blc9xxth.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87blc9xxth.fsf@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_01:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 clxscore=1015 mlxscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020029
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Feb 24, 2021 at 12:58:02PM -0300, Fabiano Rosas wrote:
> > @@ -1590,6 +1662,24 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
> >  		if (!xics_on_xive())
> >  			kvmppc_xics_rm_complete(vcpu, 0);
> >  		break;
> > +	case BOOK3S_INTERRUPT_SYSCALL:
> > +	{
> > +		unsigned long req = kvmppc_get_gpr(vcpu, 3);
> > +
> > +		/*
> > +		 * The H_RPT_INVALIDATE hcalls issued by nested
> > +		 * guests for process scoped invalidations when
> > +		 * GTSE=0, are handled here in L0.
> > +		 */
> > +		if (req == H_RPT_INVALIDATE) {
> > +			kvmppc_nested_rpt_invalidate(vcpu);
> > +			r = RESUME_GUEST;
> > +			break;
> > +		}
> 
> I'm inclined to say this is a bit too early. We're handling the hcall
> before kvmhv_run_single_vcpu has fully finished and we'll skip some
> code that has been running in all guest exits:
> 
> 	if (trap) {
> 		if (!nested)
> 			r = kvmppc_handle_exit_hv(vcpu, current);
> 		else
> 			r = kvmppc_handle_nested_exit(vcpu);  <--- we're here
> 	}
> 	vcpu->arch.ret = r;
> 
>         (...)
> 
> 	vcpu->arch.ceded = 0;
> 
> 	vc->vcore_state = VCORE_INACTIVE;
> 	trace_kvmppc_run_core(vc, 1);
> 
>  done:
> 	kvmppc_remove_runnable(vc, vcpu);
> 	trace_kvmppc_run_vcpu_exit(vcpu);
> 
> 	return vcpu->arch.ret;
> 
> Especially the kvmppc_remove_runnable function because it sets the
> vcpu state:
> 
>     	vcpu->arch.state = KVMPPC_VCPU_BUSY_IN_HOST;
> 
> which should be the case if we're handling a hypercall.
> 
> I suggest we do similarly to the L1 exit code and defer the hcall
> handling until after kvmppc_run_single_vcpu has exited, still inside the
> is_kvmppc_resume_guest(r) loop.
> 
> So we'd set:
> case BOOK3S_INTERRUPT_SYSCALL:
> 	vcpu->run->exit_reason = KVM_EXIT_PAPR_HCALL;
> 	r = RESUME_HOST;
>         break;
> 
> and perhaps introduce a new kvmppc_pseries_do_nested_hcall that's called
> after kvmppc_run_single_vcpu.

Yes, looks like we should, but I wasn't sure if an exit similar to L1
exit for hcall handling is needed here too, hence took this approach.

Paul, could you please clarify?

Regards,
Bharata.
